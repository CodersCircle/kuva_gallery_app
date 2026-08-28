import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as p;
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';

import '../../core/errors/vault_hide_exception.dart';
import '../../core/services/encryption_compute.dart';
import '../../core/services/encryption_service.dart';
import '../../core/services/hidden_albums_store.dart';
import '../../domain/models/album_model.dart';
import '../../domain/models/hidden_item.dart';
import '../datasources/isar_database.dart';
import '../datasources/photo_manager_datasource.dart';

/// Hide/unhide: encrypt to vault only — originals are never deleted from device.
class VaultRepository {
  VaultRepository({
    PhotoManagerDatasource? photoDatasource,
    EncryptionService? encryptionService,
    Isar? isar,
    HiddenAlbumsStore? hiddenAlbumsStore,
  })  : _photo = photoDatasource ?? PhotoManagerDatasource(),
        _encryption = encryptionService ?? EncryptionService(),
        _isar = isar,
        _hiddenAlbums = hiddenAlbumsStore ?? HiddenAlbumsStore();

  final PhotoManagerDatasource _photo;
  final EncryptionService _encryption;
  final Isar? _isar;
  final HiddenAlbumsStore _hiddenAlbums;
  final _uuid = const Uuid();

  Future<Isar> get _db async => _isar ?? await IsarDatabase.open();

  /// Encrypt + write + verify + Isar metadata — never touches MediaStore.
  Future<HiddenItem> _storeInVault({
    required AssetEntity entity,
    required String albumId,
    required String albumName,
    required String pin,
  }) async {
    final file = await entity.file;
    if (file == null) {
      throw VaultHideException();
    }

    final plainBytes = await file.readAsBytes();
    final originalSize = plainBytes.length;
    if (originalSize == 0) {
      throw VaultHideException();
    }

    final keyBytes = await _encryption.deriveKeyBytes(pin);
    final encryptedBytes = await compute(
      encryptBytesInIsolate,
      CipherPayload(data: plainBytes, keyBytes: keyBytes),
    );

    final vaultDir = await IsarDatabase.vaultDirectory();
    final encryptedName = '${_uuid.v4()}.enc';
    final encryptedPath = p.join(vaultDir.path, encryptedName);
    final encryptedFile = File(encryptedPath);

    try {
      await encryptedFile.parent.create(recursive: true);
      await encryptedFile.writeAsBytes(encryptedBytes, flush: true);

      final writtenOk = await encryptedFile.exists() &&
          (await encryptedFile.length()) == encryptedBytes.length;
      if (!writtenOk) {
        if (await encryptedFile.exists()) await encryptedFile.delete();
        throw VaultHideException();
      }

      final verifyDecrypt = await compute(
        decryptBytesInIsolate,
        CipherPayload(data: encryptedBytes, keyBytes: keyBytes),
      );
      if (verifyDecrypt.length != plainBytes.length) {
        await encryptedFile.delete();
        throw VaultHideException();
      }

      final item = HiddenItem()
        ..originalAssetId = entity.id
        ..originalPath = file.path
        ..albumId = albumId
        ..albumName = albumName
        ..encryptedPath = encryptedPath
        ..mimeType = entity.mimeType ?? 'application/octet-stream'
        ..isVideo = entity.type == AssetType.video
        ..originalSize = originalSize
        ..hiddenAt = DateTime.now();

      final db = await _db;
      await db.writeTxn(() async {
        await db.hiddenItems.put(item);
      });
      return item;
    } catch (e) {
      if (await encryptedFile.exists()) {
        try {
          await encryptedFile.delete();
        } catch (_) {}
      }
      if (e is VaultHideException) rethrow;
      throw VaultHideException();
    }
  }

  Future<void> _removeFromVault(HiddenItem item) async {
    final file = File(item.encryptedPath);
    if (await file.exists()) await file.delete();
    final db = await _db;
    await db.writeTxn(() async {
      await db.hiddenItems.delete(item.id);
    });
    await _maybeUnmarkAlbum(item.albumId);
  }

  /// Hide a single item — vault copy only, original stays on device.
  Future<HiddenItem> hideAsset({
    required AssetEntity entity,
    required String albumId,
    required String albumName,
    required String pin,
  }) async {
    return _storeInVault(
      entity: entity,
      albumId: albumId,
      albumName: albumName,
      pin: pin,
    );
  }

  /// Batch-hide album — vault all items, hide album in Kuva (no device delete).
  Future<List<HiddenItem>> hideAlbum({
    required AlbumModel album,
    required String pin,
    void Function(int current, int total)? onProgress,
    bool Function()? shouldCancel,
  }) async {
    final assets = await _photo.getAllAssetsInAlbum(album.assetPath);
    if (assets.isEmpty) return [];

    final hidden = <HiddenItem>[];

    try {
      for (var i = 0; i < assets.length; i++) {
        if (shouldCancel?.call() == true) {
          throw VaultHideException('Hide cancelled');
        }
        onProgress?.call(i + 1, assets.length);
        final item = await _storeInVault(
          entity: assets[i],
          albumId: album.id,
          albumName: album.name,
          pin: pin,
        );
        hidden.add(item);
      }

      await _hiddenAlbums.markAlbumHidden(album.id);
      return hidden;
    } catch (e) {
      for (final item in hidden) {
        await _removeFromVault(item);
      }
      if (e is VaultHideException) rethrow;
      throw VaultHideException();
    }
  }

  Future<List<HiddenItem>> getHiddenItems() async {
    final db = await _db;
    return db.hiddenItems.where().sortByHiddenAtDesc().findAll();
  }

  Future<Set<String>> getHiddenAssetIds() async {
    final items = await getHiddenItems();
    return items.map((i) => i.originalAssetId).toSet();
  }

  Future<File> decryptForViewing(HiddenItem item, String pin) {
    return _encryption.decryptToTemp(File(item.encryptedPath), pin: pin);
  }

  Future<void> unhideItem(HiddenItem item, String pin) async {
    await _restoreHiddenItem(item, pin);
    final db = await _db;
    await db.writeTxn(() async {
      await db.hiddenItems.delete(item.id);
    });
    await _maybeUnmarkAlbum(item.albumId);
  }

  Future<void> _restoreHiddenItem(HiddenItem item, String pin) async {
    final existing = await AssetEntity.fromId(item.originalAssetId);
    if (existing != null) {
      // Vault-only hide: original is still on device — drop vault copy only.
      await File(item.encryptedPath).delete();
      return;
    }

    // Legacy: item was removed from gallery — restore from vault.
    final decrypted = await _encryption.decryptToTemp(
      File(item.encryptedPath),
      pin: pin,
    );
    if (item.isVideo) {
      await PhotoManager.editor.saveVideo(
        decrypted,
        title: p.basename(item.originalPath),
      );
    } else {
      await PhotoManager.editor.saveImageWithPath(
        decrypted.path,
        title: p.basename(item.originalPath),
      );
    }
    await File(item.encryptedPath).delete();
    try {
      await decrypted.delete();
    } catch (_) {}
  }

  Future<void> deleteHiddenItem(HiddenItem item) async {
    final file = File(item.encryptedPath);
    if (await file.exists()) await file.delete();
    final db = await _db;
    await db.writeTxn(() async {
      await db.hiddenItems.delete(item.id);
    });
    await _maybeUnmarkAlbum(item.albumId);
  }

  Future<void> _maybeUnmarkAlbum(String albumId) async {
    final db = await _db;
    final count =
        await db.hiddenItems.filter().albumIdEqualTo(albumId).count();
    if (count == 0) {
      await _hiddenAlbums.unmarkAlbum(albumId);
    }
  }

  @visibleForTesting
  Future<HiddenItem> storeInVaultForTest({
    required Uint8List plainBytes,
    required String assetId,
    required String originalPath,
    required String albumId,
    required String albumName,
    required String pin,
    required bool isVideo,
    String mimeType = 'image/jpeg',
  }) async {
    final keyBytes = await _encryption.deriveKeyBytes(pin);
    final encryptedBytes = await compute(
      encryptBytesInIsolate,
      CipherPayload(data: plainBytes, keyBytes: keyBytes),
    );

    final vaultDir = await IsarDatabase.vaultDirectory();
    final encryptedPath = p.join(vaultDir.path, '${_uuid.v4()}.enc');
    final encryptedFile = File(encryptedPath);
    await encryptedFile.parent.create(recursive: true);
    await encryptedFile.writeAsBytes(encryptedBytes, flush: true);

    final writtenOk = await encryptedFile.exists() &&
        (await encryptedFile.length()) == encryptedBytes.length;
    if (!writtenOk) {
      if (await encryptedFile.exists()) await encryptedFile.delete();
      throw VaultHideException();
    }

    final verifyDecrypt = await compute(
      decryptBytesInIsolate,
      CipherPayload(data: encryptedBytes, keyBytes: keyBytes),
    );
    if (verifyDecrypt.length != plainBytes.length) {
      await encryptedFile.delete();
      throw VaultHideException();
    }

    final item = HiddenItem()
      ..originalAssetId = assetId
      ..originalPath = originalPath
      ..albumId = albumId
      ..albumName = albumName
      ..encryptedPath = encryptedPath
      ..mimeType = mimeType
      ..isVideo = isVideo
      ..originalSize = plainBytes.length
      ..hiddenAt = DateTime.now();

    final db = await _db;
    await db.writeTxn(() async {
      await db.hiddenItems.put(item);
    });
    return item;
  }

  @visibleForTesting
  Future<Uint8List> decryptVaultBytesForTest(HiddenItem item, String pin) async {
    final keyBytes = await _encryption.deriveKeyBytes(pin);
    final encryptedBytes = await File(item.encryptedPath).readAsBytes();
    return compute(
      decryptBytesInIsolate,
      CipherPayload(data: encryptedBytes, keyBytes: keyBytes),
    );
  }
}
