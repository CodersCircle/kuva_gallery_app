import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:share_plus/share_plus.dart';

/// Shares local media files via the system share sheet.
class ShareService {
  ShareService._();
  static final ShareService instance = ShareService._();

  Future<void> shareAssets(
    List<AssetEntity> assets, {
    required BuildContext context,
  }) async {
    if (assets.isEmpty) return;

    final files = <XFile>[];
    var skipped = 0;
    for (final asset in assets) {
      final file = await asset.file;
      if (file != null) {
        files.add(XFile(file.path));
      } else {
        skipped++;
      }
    }

    if (files.isEmpty) {
      if (context.mounted) {
        _toast(context, 'Some items couldn\'t be shared.');
      }
      return;
    }

    try {
      await SharePlus.instance.share(ShareParams(files: files));
    } on PlatformException catch (e) {
      if (context.mounted) {
        _toast(
          context,
          'Sharing failed — some apps only accept one media type at a time. '
          'Try sharing fewer items or one type at a time.',
        );
      }
      debugPrint('ShareService: platform error $e');
    } catch (e) {
      if (context.mounted) {
        _toast(context, 'Sharing failed: $e');
      }
    }

    if (skipped > 0 && context.mounted) {
      _toast(context, 'Some items couldn\'t be shared.');
    }
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
