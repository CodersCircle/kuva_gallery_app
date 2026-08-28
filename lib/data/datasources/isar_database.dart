import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/models/album_cover_cache.dart';
import '../../domain/models/album_usage_stats.dart';
import '../../domain/models/cloud_target.dart';
import '../../domain/models/hidden_item.dart';
import '../../domain/models/locked_album.dart';
import '../../domain/models/upload_queue_item.dart';

/// Opens and provides the Isar database singleton.
class IsarDatabase {
  IsarDatabase._();
  static Isar? _instance;

  static Future<Isar> open() async {
    if (_instance != null && _instance!.isOpen) return _instance!;

    final dir = await getApplicationDocumentsDirectory();
    _instance = await Isar.open(
      [
        HiddenItemSchema,
        LockedAlbumSchema,
        CloudTargetSchema,
        UploadQueueItemSchema,
        AlbumCoverCacheSchema,
        AlbumUsageStatsSchema,
      ],
      directory: dir.path,
      name: 'kuva_gallery',
    );
    return _instance!;
  }

  static Future<void> close() async {
    await _instance?.close();
    _instance = null;
  }

  /// Vault directory inside app sandbox.
  static Future<Directory> vaultDirectory() async {
    final docs = await getApplicationDocumentsDirectory();
    final vault = Directory('${docs.path}/vault');
    if (!await vault.exists()) {
      await vault.create(recursive: true);
    }
    return vault;
  }
}
