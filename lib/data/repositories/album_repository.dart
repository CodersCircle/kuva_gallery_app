import 'package:isar/isar.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/pin_service.dart';
import '../../domain/models/album_model.dart';
import '../../domain/models/locked_album.dart';
import '../datasources/isar_database.dart';
import '../datasources/photo_manager_datasource.dart';

/// Album enumeration and size caching.
class AlbumRepository {
  AlbumRepository({
    PhotoManagerDatasource? datasource,
    Isar? isar,
  })  : _datasource = datasource ?? PhotoManagerDatasource(),
        _isar = isar;

  final PhotoManagerDatasource _datasource;
  final Isar? _isar;
  final _sizeCache = <String, int>{};

  Future<List<AlbumModel>> getAlbums() => _datasource.getAlbums();

  Future<int> getAlbumSize(AlbumModel album) async {
    if (_sizeCache.containsKey(album.id)) {
      return _sizeCache[album.id]!;
    }
    final size = await _datasource.computeAlbumSize(album);
    _sizeCache[album.id] = size;
    return size;
  }

  void invalidateSizeCache(String albumId) => _sizeCache.remove(albumId);
}

/// Per-album PIN lock management.
class LockRepository {
  LockRepository({
    Isar? isar,
    PinService? pinService,
  })  : _isar = isar,
        _pinService = pinService ?? PinService();

  final Isar? _isar;
  final PinService _pinService;

  Future<Isar> get _db async => _isar ?? await IsarDatabase.open();

  Future<LockedAlbum?> _findLock(String albumId) async {
    final db = await _db;
    return db.lockedAlbums.filter().albumIdEqualTo(albumId).findFirst();
  }

  Future<bool> isAlbumLocked(String albumId) async {
    return (await _findLock(albumId)) != null;
  }

  /// Locks an album with the given 4-digit PIN (stored per-album).
  Future<void> lockAlbum({
    required String albumId,
    required String pin,
  }) async {
    if (!PinService.isValidFormat(pin)) {
      throw ArgumentError('PIN must be exactly ${AppConstants.pinLength} digits');
    }

    if (!await _pinService.isPinSet()) {
      await _pinService.setPin(pin);
    }

    final salt = PinService.generateSalt();
    final hash = PinService.hashPinWithSalt(pin, salt);

    final db = await _db;
    await db.writeTxn(() async {
      await db.lockedAlbums.filter().albumIdEqualTo(albumId).deleteAll();
      final lock = LockedAlbum()
        ..albumId = albumId
        ..useMasterPin = false
        ..pinHash = hash
        ..pinSalt = salt;
      await db.lockedAlbums.put(lock);
    });
  }

  Future<void> unlockAlbum(String albumId) async {
    final db = await _db;
    await db.writeTxn(() async {
      await db.lockedAlbums.filter().albumIdEqualTo(albumId).deleteAll();
    });
  }

  /// True when album uses legacy master-PIN lock but app PIN was cleared.
  Future<bool> isOrphanedAlbumLock(String albumId) async {
    final lock = await _findLock(albumId);
    if (lock == null) return false;
    if (lock.pinHash.isNotEmpty) return false;
    return lock.useMasterPin && !await _pinService.isPinSet();
  }

  /// Repairs a legacy orphaned lock by saving the PIN and re-locking the album.
  Future<void> repairOrphanedAlbumLock({
    required String albumId,
    required String pin,
  }) async {
    if (!PinService.isValidFormat(pin)) {
      throw ArgumentError('Invalid PIN');
    }
    await _pinService.setPin(pin);
    await lockAlbum(albumId: albumId, pin: pin);
  }

  Future<bool> verifyAlbumPin(String albumId, String pin) async {
    if (!PinService.isValidFormat(pin)) return false;

    final lock = await _findLock(albumId);
    if (lock == null) return true;

    if (lock.pinHash.isNotEmpty) {
      return PinService.hashPinWithSalt(pin, lock.pinSalt) == lock.pinHash;
    }

    // Legacy: master-PIN lock from older builds.
    if (lock.useMasterPin) {
      if (!await _pinService.isPinSet()) return false;
      return _pinService.verifyPin(pin);
    }

    return false;
  }

  /// Removes legacy master-PIN locks when the app PIN was reset.
  Future<void> clearOrphanedMasterPinLocks() async {
    if (await _pinService.isPinSet()) return;
    final db = await _db;
    await db.writeTxn(() async {
      final orphans = await db.lockedAlbums
          .filter()
          .useMasterPinEqualTo(true)
          .pinHashEqualTo('')
          .findAll();
      for (final lock in orphans) {
        await db.lockedAlbums.delete(lock.id);
      }
    });
  }
}
