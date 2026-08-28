import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;

import 'cloud_uploader.dart';

/// Google Drive uploader using OAuth via google_sign_in.
class GoogleDriveUploader implements CloudUploader {
  GoogleDriveUploader({
    required this.folderId,
    GoogleSignIn? signIn,
  }) : _signIn = signIn ??
            GoogleSignIn(
              scopes: [drive.DriveApi.driveFileScope],
            );

  final String folderId;
  final GoogleSignIn _signIn;

  Future<String> _accessToken() async {
    final account = await _signIn.signInSilently() ?? await _signIn.signIn();
    if (account == null) throw StateError('Google sign-in cancelled');
    final headers = await account.authHeaders;
    final auth = headers['Authorization'];
    if (auth == null || !auth.startsWith('Bearer ')) {
      throw StateError('No access token');
    }
    return auth.substring(7);
  }

  @override
  String get providerName => 'Google Drive';

  @override
  Future<void> uploadFile(
    File file, {
    required String remotePath,
    required void Function(double progress) onProgress,
  }) async {
    final token = await _accessToken();
    final dio = Dio();
    final fileName = remotePath.split('/').last;

    final metadata = {
      'name': fileName,
      if (folderId.isNotEmpty) 'parents': [folderId],
    };

    final formData = FormData.fromMap({
      'metadata': MultipartFile.fromString(
        jsonEncode(metadata),
        contentType: DioMediaType.parse('application/json'),
      ),
      'file': await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    await dio.post(
      'https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart',
      data: formData,
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        contentType: 'multipart/related',
      ),
      onSendProgress: (sent, total) {
        if (total > 0) onProgress(sent / total);
      },
    );
    onProgress(1.0);
  }

  @override
  Future<bool> testConnection() async {
    try {
      final token = await _accessToken();
      final dio = Dio();
      final response = await dio.get(
        'https://www.googleapis.com/drive/v3/about',
        queryParameters: {'fields': 'user'},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Map<String, dynamic> configFromJson(String json) {
    return jsonDecode(json) as Map<String, dynamic>;
  }

  static String configToJson({required String folderId}) {
    return jsonEncode({'folderId': folderId});
  }
}
