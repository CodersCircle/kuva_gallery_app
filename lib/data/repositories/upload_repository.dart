import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/models/cloud_target.dart';
import '../../domain/models/upload_queue_item.dart';
import '../datasources/cloud/cloud_uploader.dart';
import '../datasources/cloud/cloudinary_uploader.dart';
import '../datasources/cloud/google_drive_uploader.dart';
import '../datasources/cloud/s3_uploader.dart';
import '../datasources/isar_database.dart';

/// Upload queue with retry logic and exponential backoff.
class UploadRepository {
  UploadRepository({Isar? isar}) : _isar = isar;

  final Isar? _isar;

  Future<Isar> get _db async => _isar ?? await IsarDatabase.open();

  Future<void> enqueue({
    required String localPath,
    required String fileName,
    required String albumId,
    required int cloudTargetId,
    bool isVaultItem = false,
  }) async {
    final item = UploadQueueItem()
      ..localPath = localPath
      ..fileName = fileName
      ..albumId = albumId
      ..cloudTargetId = cloudTargetId.toString()
      ..status = UploadStatus.queued
      ..retryCount = 0
      ..progress = 0
      ..isVaultItem = isVaultItem
      ..createdAt = DateTime.now();

    final db = await _db;
    await db.writeTxn(() async {
      await db.uploadQueueItems.put(item);
    });
  }

  Future<List<UploadQueueItem>> getQueue() async {
    final db = await _db;
    return db.uploadQueueItems.where().sortByCreatedAt().findAll();
  }

  Future<List<CloudTarget>> getCloudTargets() async {
    final db = await _db;
    return db.cloudTargets.where().findAll();
  }

  Future<void> saveCloudTarget(CloudTarget target) async {
    final db = await _db;
    await db.writeTxn(() async {
      await db.cloudTargets.put(target);
    });
  }

  CloudUploader? uploaderForTarget(CloudTarget target) {
    switch (target.provider) {
      case CloudProvider.googleDrive:
        final config = GoogleDriveUploader.configFromJson(target.configJson);
        return GoogleDriveUploader(folderId: config['folderId'] as String? ?? '');
      case CloudProvider.cloudinary:
        return CloudinaryUploader.fromConfig(target.configJson);
      case CloudProvider.s3:
        return S3Uploader.fromConfig(target.configJson);
    }
  }

  /// Process pending queue items. Returns count of successful uploads.
  Future<int> processQueue({
    void Function(UploadQueueItem item)? onItemUpdate,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final wifiOnly = prefs.getBool(AppConstants.prefWifiOnlyBackup) ?? true;
    if (wifiOnly) {
      final connectivity = await Connectivity().checkConnectivity();
      if (!connectivity.contains(ConnectivityResult.wifi)) {
        return 0;
      }
    }

    final db = await _db;
    final pending = await db.uploadQueueItems
        .filter()
        .group((q) => q
            .statusEqualTo(UploadStatus.queued)
            .or()
            .statusEqualTo(UploadStatus.failed))
        .findAll();

    var successCount = 0;
    for (final item in pending) {
      if (item.retryCount >= AppConstants.maxUploadRetries) continue;

      final targetId = int.tryParse(item.cloudTargetId);
      if (targetId == null) continue;
      final target = await db.cloudTargets.get(targetId);
      if (target == null || !target.isConnected) continue;

      final uploader = uploaderForTarget(target);
      if (uploader == null) continue;

      item.status = UploadStatus.uploading;
      await db.writeTxn(() => db.uploadQueueItems.put(item));
      onItemUpdate?.call(item);

      try {
        var file = File(item.localPath);
        final dataSaver = prefs.getBool(AppConstants.prefDataSaver) ?? false;
        if (dataSaver && !item.isVaultItem && _isImage(file.path)) {
          file = await _compressImage(file);
        }

        await uploader.uploadFile(
          file,
          remotePath: 'kuva/${item.albumId}/${item.fileName}',
          onProgress: (p) {
            item.progress = p;
            onItemUpdate?.call(item);
          },
        );

        item.status = UploadStatus.done;
        item.progress = 1.0;
        item.completedAt = DateTime.now();
        successCount++;
      } catch (e) {
        item.status = UploadStatus.failed;
        item.retryCount++;
        item.errorMessage = e.toString();
        await backoff(item.retryCount);
      }

      await db.writeTxn(() => db.uploadQueueItems.put(item));
      onItemUpdate?.call(item);
    }

    if (successCount > 0) {
      await prefs.setString(
        AppConstants.prefLastSyncTime,
        DateTime.now().toIso8601String(),
      );
    }
    return successCount;
  }

  bool _isImage(String path) {
    final ext = p.extension(path).toLowerCase();
    return ['.jpg', '.jpeg', '.png', '.webp', '.heic'].contains(ext);
  }

  Future<File> _compressImage(File file) async {
    final dir = p.dirname(file.path);
    final out = File(p.join(dir, 'compressed_${p.basename(file.path)}'));
    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      out.path,
      quality: 75,
    );
    return result != null ? File(result.path) : file;
  }

  /// Exponential backoff delay for retries.
  static int backoffSeconds(int retryCount) {
    return pow(2, retryCount).toInt().clamp(1, 300);
  }

  static Future<void> backoff(int retryCount) async {
    final seconds = backoffSeconds(retryCount);
    await Future<void>.delayed(Duration(seconds: seconds));
  }
}
