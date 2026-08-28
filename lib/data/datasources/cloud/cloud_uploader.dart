import 'dart:io';

/// Abstract cloud upload interface.
abstract class CloudUploader {
  String get providerName;

  Future<void> uploadFile(
    File file, {
    required String remotePath,
    required void Function(double progress) onProgress,
  });

  Future<bool> testConnection();
}
