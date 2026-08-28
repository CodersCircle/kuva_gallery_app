import 'dart:convert';
import 'dart:io';

import 'package:aws_s3_upload_lite/aws_s3_upload_lite.dart';
import 'package:path/path.dart' as p;

import 'cloud_uploader.dart';

/// S3-compatible uploader (AWS, Wasabi, MinIO, Backblaze).
class S3Uploader implements CloudUploader {
  S3Uploader({
    required this.accessKey,
    required this.secretKey,
    required this.bucket,
    required this.region,
    this.endpoint,
  });

  final String accessKey;
  final String secretKey;
  final String bucket;
  final String region;
  final String? endpoint;

  @override
  String get providerName => 'S3';

  @override
  Future<void> uploadFile(
    File file, {
    required String remotePath,
    required void Function(double progress) onProgress,
  }) async {
    final fileName = p.basename(remotePath);
    final destDir = p.dirname(remotePath).replaceAll('\\', '/');

    await AwsS3.uploadFile(
      accessKey: accessKey,
      secretKey: secretKey,
      bucket: bucket,
      region: region,
      file: file,
      destDir: destDir == '.' ? '' : destDir,
      filename: fileName,
      onUploadProgress: (sent, total) {
        if (total > 0) onProgress(sent / total);
      },
    );
    onProgress(1.0);
  }

  @override
  Future<bool> testConnection() async {
    return accessKey.isNotEmpty && secretKey.isNotEmpty && bucket.isNotEmpty;
  }

  static String configToJson({
    required String accessKey,
    required String secretKey,
    required String bucket,
    required String region,
    String? endpoint,
  }) {
    return jsonEncode({
      'accessKey': accessKey,
      'secretKey': secretKey,
      'bucket': bucket,
      'region': region,
      'endpoint': endpoint,
    });
  }

  static S3Uploader fromConfig(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return S3Uploader(
      accessKey: map['accessKey'] as String,
      secretKey: map['secretKey'] as String,
      bucket: map['bucket'] as String,
      region: map['region'] as String,
      endpoint: map['endpoint'] as String?,
    );
  }
}
