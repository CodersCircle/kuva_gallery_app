import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';

/// Thumbnail load outcome for UI branching.
enum ThumbnailLoadStatus {
  success,
  retryable,
  unavailable,
}

class ThumbnailLoadResult {
  const ThumbnailLoadResult({
    required this.status,
    this.bytes,
  });

  final ThumbnailLoadStatus status;
  final Uint8List? bytes;
}

/// Priority for the thumbnail request queue.
enum ThumbnailPriority { high, low }

/// Square 300×300 thumb for all grid densities.
ThumbnailSize thumbnailSizeForColumns(int columns) {
  return const ThumbnailSize(300, 300);
}

/// Decode width for [Image.memory] — tile width × DPR, aspect preserved.
int decodeCacheWidthForTile(double screenWidth, int columns, double dpr) {
  final tileWidth = screenWidth / columns;
  return (tileWidth * dpr).round().clamp(64, 600);
}

/// Priority queue + exponential backoff + cloud-stub detection.
class ThumbnailCacheService {
  ThumbnailCacheService._();
  static final ThumbnailCacheService instance = ThumbnailCacheService._();

  static const _maxMemoryEntries = 200;
  static const _maxConcurrent = 6;
  static const _maxDiskBytes = 200 * 1024 * 1024; // 200 MB LRU cap
  static const _backoffDelays = [
    Duration(milliseconds: 500),
    Duration(milliseconds: 1500),
    Duration(milliseconds: 4000),
  ];

  final _memory = <String, Uint8List>{};
  final _order = <String>[];
  final _futureCache = <String, Future<ThumbnailLoadResult>>{};
  final _unavailable = <String>{};
  var _activeLoads = 0;
  final _highQueue = <_QueueEntry>[];
  final _lowQueue = <_QueueEntry>[];

  String _key(String assetId, int w, int h) => '${assetId}_${w}x$h';

  Future<Directory> _diskDir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'thumb_cache'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Uint8List? memoryGet(String assetId, ThumbnailSize size) {
    final key = _key(assetId, size.width, size.height);
    if (!_memory.containsKey(key)) return null;
    _order.remove(key);
    _order.add(key);
    return _memory[key];
  }

  void memoryPut(String assetId, ThumbnailSize size, Uint8List bytes) {
    final key = _key(assetId, size.width, size.height);
    _order.remove(key);
    _order.add(key);
    _memory[key] = bytes;
    while (_order.length > _maxMemoryEntries) {
      final evict = _order.removeAt(0);
      _memory.remove(evict);
    }
  }

  Future<Uint8List?> diskGet(String assetId, ThumbnailSize size) async {
    final file = File(
      p.join(
        (await _diskDir()).path,
        '${_key(assetId, size.width, size.height)}.bin',
      ),
    );
    if (!await file.exists()) return null;
    return file.readAsBytes();
  }

  Future<void> diskPut(
    String assetId,
    ThumbnailSize size,
    Uint8List bytes,
  ) async {
    final file = File(
      p.join(
        (await _diskDir()).path,
        '${_key(assetId, size.width, size.height)}.bin',
      ),
    );
    await file.writeAsBytes(bytes, flush: true);
    await _evictDiskCacheIfNeeded();
  }

  Future<void> _evictDiskCacheIfNeeded() async {
    final dir = await _diskDir();
    final files = await dir
        .list()
        .where((e) => e is File && e.path.endsWith('.bin'))
        .cast<File>()
        .toList();
    var total = 0;
    final entries = <({File file, int size, DateTime accessed})>[];
    for (final file in files) {
      final stat = await file.stat();
      total += stat.size;
      entries.add((file: file, size: stat.size, accessed: stat.accessed));
    }
    if (total <= _maxDiskBytes) return;

    entries.sort((a, b) => a.accessed.compareTo(b.accessed));
    for (final entry in entries) {
      if (total <= _maxDiskBytes) break;
      await entry.file.delete();
      total -= entry.size;
    }
  }

  bool isUnavailable(String assetId, ThumbnailSize size) {
    return _unavailable.contains(_key(assetId, size.width, size.height));
  }

  Future<ThumbnailLoadResult> loadThumbnail(
    AssetEntity entity,
    ThumbnailSize size, {
    ThumbnailPriority priority = ThumbnailPriority.low,
    bool forceRefresh = false,
  }) {
    final key = _key(entity.id, size.width, size.height);

    if (!forceRefresh) {
      if (_unavailable.contains(key)) {
        return SynchronousFuture(
          const ThumbnailLoadResult(status: ThumbnailLoadStatus.unavailable),
        );
      }
      final cached = memoryGet(entity.id, size);
      if (cached != null) {
        return SynchronousFuture(
          ThumbnailLoadResult(
            status: ThumbnailLoadStatus.success,
            bytes: cached,
          ),
        );
      }
      final existing = _futureCache[key];
      if (existing != null) return existing;
    } else {
      _futureCache.remove(key);
      _unavailable.remove(key);
    }

    final future = _loadThumbnail(entity, size, priority);
    _futureCache[key] = future;
    return future;
  }

  Future<ThumbnailLoadResult> _loadThumbnail(
    AssetEntity entity,
    ThumbnailSize size,
    ThumbnailPriority priority,
  ) async {
    final key = _key(entity.id, size.width, size.height);

    final fromDisk = await diskGet(entity.id, size);
    if (fromDisk != null) {
      memoryPut(entity.id, size, fromDisk);
      return ThumbnailLoadResult(
        status: ThumbnailLoadStatus.success,
        bytes: fromDisk,
      );
    }

    await _acquireSlot(priority);
    try {
      Uint8List? bytes;
      for (var attempt = 0; attempt <= _backoffDelays.length; attempt++) {
        bytes = await _fetchNative(entity, size, attempt);
        if (bytes != null) break;
        if (attempt < _backoffDelays.length) {
          await Future<void>.delayed(_backoffDelays[attempt]);
        }
      }

      if (bytes != null) {
        memoryPut(entity.id, size, bytes);
        await diskPut(entity.id, size, bytes);
        return ThumbnailLoadResult(
          status: ThumbnailLoadStatus.success,
          bytes: bytes,
        );
      }

      final localFile = await entity.file;
      if (localFile == null || !await localFile.exists()) {
        _unavailable.add(key);
        _futureCache.remove(key);
        if (kDebugMode) {
          debugPrint(
            'ThumbnailCacheService: unavailable (null-file) asset=${entity.id} '
            'type=${entity.type}',
          );
        }
        return const ThumbnailLoadResult(
          status: ThumbnailLoadStatus.unavailable,
        );
      }

      _futureCache.remove(key);
      if (kDebugMode) {
        debugPrint(
          'ThumbnailCacheService: retryable failure asset=${entity.id} '
            'after ${_backoffDelays.length + 1} attempts',
        );
      }
      return const ThumbnailLoadResult(status: ThumbnailLoadStatus.retryable);
    } finally {
      _releaseSlot();
    }
  }

  Future<Uint8List?> _fetchNative(
    AssetEntity entity,
    ThumbnailSize size,
    int attempt,
  ) async {
    try {
      final bytes = await entity
          .thumbnailDataWithSize(size)
          .timeout(const Duration(seconds: 5));
      if (bytes == null || bytes.isEmpty) {
        if (kDebugMode) {
          debugPrint(
            'ThumbnailCacheService: null-bytes asset=${entity.id} '
            'attempt=$attempt',
          );
        }
        return null;
      }
      return bytes;
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          'ThumbnailCacheService: timeout/error asset=${entity.id} '
          'attempt=$attempt error=$e',
        );
      }
      return null;
    }
  }

  Future<void> _acquireSlot(ThumbnailPriority priority) async {
    if (_activeLoads < _maxConcurrent) {
      _activeLoads++;
      return;
    }
    final entry = _QueueEntry(priority);
    if (priority == ThumbnailPriority.high) {
      _highQueue.add(entry);
    } else {
      _lowQueue.add(entry);
    }
    await entry.completer.future;
    _activeLoads++;
  }

  void _releaseSlot() {
    _activeLoads--;
    if (_highQueue.isNotEmpty) {
      _highQueue.removeAt(0).completer.complete();
      return;
    }
    if (_lowQueue.isNotEmpty) {
      _lowQueue.removeAt(0).completer.complete();
    }
  }
}

class _QueueEntry {
  _QueueEntry(this.priority);
  final ThumbnailPriority priority;
  final completer = Completer<void>();
}

Future<Uint8List?> copyThumbnailBytes(Uint8List input) async {
  return compute(_copyBytes, input);
}

Uint8List _copyBytes(Uint8List input) => Uint8List.fromList(input);
