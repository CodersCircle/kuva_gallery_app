import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:dio/dio.dart';

import 'cloud_uploader.dart';

/// Cloudinary uploader using signed upload API.
class CloudinaryUploader implements CloudUploader {
  CloudinaryUploader({
    required this.cloudName,
    required this.apiKey,
    required this.apiSecret,
    this.uploadPreset,
    Dio? dio,
  }) : _dio = dio ?? Dio();

  final String cloudName;
  final String apiKey;
  final String apiSecret;
  final String? uploadPreset;
  final Dio _dio;

  @override
  String get providerName => 'Cloudinary';

  @override
  Future<void> uploadFile(
    File file, {
    required String remotePath,
    required void Function(double progress) onProgress,
  }) async {
    final url = 'https://api.cloudinary.com/v1_1/$cloudName/auto/upload';
    final fileName = remotePath.split('/').last;

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
      if (uploadPreset != null) 'upload_preset': uploadPreset,
      'api_key': apiKey,
      'timestamp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'public_id': fileName,
    });

    await _dio.post(
      url,
      data: formData,
      onSendProgress: (sent, total) {
        if (total > 0) onProgress(sent / total);
      },
      options: Options(
        headers: {'X-Requested-With': 'XMLHttpRequest'},
      ),
    );
    onProgress(1.0);
  }

  @override
  Future<bool> testConnection() async {
    try {
      final cloudinary = Cloudinary.fromCloudName(cloudName: cloudName);
      cloudinary.image('sample').toString();
      return cloudName.isNotEmpty && apiKey.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static String configToJson({
    required String cloudName,
    required String apiKey,
    required String apiSecret,
    String? uploadPreset,
  }) {
    return jsonEncode({
      'cloudName': cloudName,
      'apiKey': apiKey,
      'apiSecret': apiSecret,
      'uploadPreset': uploadPreset,
    });
  }

  static CloudinaryUploader fromConfig(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return CloudinaryUploader(
      cloudName: map['cloudName'] as String,
      apiKey: map['apiKey'] as String,
      apiSecret: map['apiSecret'] as String,
      uploadPreset: map['uploadPreset'] as String?,
    );
  }
}
