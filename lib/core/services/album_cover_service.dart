import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../data/datasources/isar_database.dart';
import '../../domain/models/album_cover_cache.dart';

/// Fetches, caches, and preloads album cover thumbnails (#Step 2–3).
class AlbumCoverService {
  AlbumCoverService._();
  static final AlbumCoverService instance = AlbumCoverService._();

  static const _coverSize = ThumbnailSize(200, 200);
  static const _maxMemoryEntries = 100;
  static const _maxConcurrent = 6;

  final _memory = <String, Uint8List>{};
  final _order = <String>[];
  final _inFlight = <String, Future<Uint8List?>>{};
  var _activeLoads = 0;
  final _waitQueue = <Completer<void>>[];

  static final _recentFirstFilter = FilterOptionGroup(
    orders: [
      const OrderOption(type: OrderOptionType.createDate, asc: false),
    ],
  );

  /// Single most-recent asset thumb — never scans full album (#Step 2).
  Future<Uint8List?> getAlbumCoverThumbnail(
    AssetPathEntity album,
    String albumId,
  ) async {
    final mem = _memoryGet(albumId);
    if (mem != null) return mem;

    final existing = _inFlight[albumId];
    if (existing != null) return existing;

    final future = _loadCover(album, albumId);
    _inFlight[albumId] = future;
    try {
      return await future;
    } finally {
      _inFlight.remove(albumId);
    }
  }

  Future<Uint8List?> _loadCover(AssetPathEntity album, String albumId) async {
    final fromIsar = await _readFromIsar(albumId);
    if (fromIsar != null) {
      _memoryPut(albumId, fromIsar);
      return fromIsar;
    }

    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.hasAccess) {
      debugPrint(
        'AlbumCoverService: permission denied (isAuth=${permission.isAuth})',
      );
      return null;
    }

    await _acquireSlot();
    try {
      final bytes = await _fetchCoverBytes(album);
      if (bytes != null) {
        _memoryPut(albumId, bytes);
        await _writeToIsar(albumId, bytes);
      }
      return bytes;
    } finally {
      _releaseSlot();
    }
  }

  Future<Uint8List?> _fetchCoverBytes(AssetPathEntity album) async {
    final count = await album.assetCountAsync;
    if (count == 0) return null;

    // createDate desc via path filter — only fetch 1 asset, not 5409 (#Step 2).
    final sortedAlbum = album.copyWith(filterOption: _recentFirstFilter);
    final recentPage = await sortedAlbum.getAssetListRange(start: 0, end: 1);
    if (recentPage.isEmpty) return null;

    final coverAsset = recentPage.first;
    try {
      final bytes = await coverAsset
          .thumbnailDataWithSize(_coverSize)
          .timeout(const Duration(seconds: 5));
      if (bytes == null || bytes.isEmpty) return null;
      return bytes;
    } catch (e) {
      debugPrint('AlbumCoverService: thumbnail failed for ${album.id}: $e');
      return null;
    }
  }

  /// Preload covers with concurrency cap of 6 (#Step 3).
  Future<void> preloadCovers(
    List<({String id, AssetPathEntity path})> albums,
  ) async {
    await Future.wait(
      albums.map((a) => getAlbumCoverThumbnail(a.path, a.id)),
    );
  }

  Future<void> _acquireSlot() async {
    if (_activeLoads < _maxConcurrent) {
      _activeLoads++;
      return;
    }
    final completer = Completer<void>();
    _waitQueue.add(completer);
    await completer.future;
    _activeLoads++;
  }

  void _releaseSlot() {
    _activeLoads--;
    if (_waitQueue.isEmpty) return;
    _waitQueue.removeAt(0).complete();
  }

  Uint8List? _memoryGet(String albumId) {
    if (!_memory.containsKey(albumId)) return null;
    _order.remove(albumId);
    _order.add(albumId);
    return _memory[albumId];
  }

  void _memoryPut(String albumId, Uint8List bytes) {
    _order.remove(albumId);
    _order.add(albumId);
    _memory[albumId] = bytes;
    while (_order.length > _maxMemoryEntries) {
      final evict = _order.removeAt(0);
      _memory.remove(evict);
    }
  }

  Future<Uint8List?> _readFromIsar(String albumId) async {
    try {
      final db = await IsarDatabase.open();
      final row = await db.albumCoverCaches
          .filter()
          .albumIdEqualTo(albumId)
          .findFirst();
      if (row == null || row.bytes.isEmpty) return null;
      return Uint8List.fromList(row.bytes);
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeToIsar(String albumId, Uint8List bytes) async {
    try {
      final db = await IsarDatabase.open();
      final row = AlbumCoverCache()
        ..albumId = albumId
        ..bytes = bytes;
      await db.writeTxn(() async {
        await db.albumCoverCaches.put(row);
      });
    } catch (_) {}
  }
}
