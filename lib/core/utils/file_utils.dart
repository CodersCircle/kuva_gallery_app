import 'dart:io';

import 'package:intl/intl.dart';

/// File size formatting and path helpers.
class FileUtils {
  FileUtils._();

  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  static String formatDate(DateTime date) {
    return DateFormat.yMMMd().add_jm().format(date);
  }

  static Future<int> fileSize(File file) async {
    try {
      return await file.length();
    } catch (_) {
      return 0;
    }
  }

  static String fileName(String path) {
    return path.split(Platform.pathSeparator).last;
  }
}
