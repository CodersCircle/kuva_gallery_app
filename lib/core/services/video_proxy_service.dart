import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:ffmpeg_kit_flutter_new_min_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new_min_gpl/return_code.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';

import 'heavy_video_detector.dart';

/// Generates cached H.264 8-bit preview proxies — originals are never modified.
class VideoProxyService {
  VideoProxyService._();
  static final VideoProxyService instance = VideoProxyService._();

  final _inFlight = <String, Future<File?>>{};

  Future<Directory> _proxyRoot() async {
    final base = await getTemporaryDirectory();
    final dir = Directory(p.join(base.path, 'kuva_video_proxies'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  String _cacheKey(AssetEntity entity, File original) {
    final modified = entity.modifiedDateTime.millisecondsSinceEpoch;
    final digest = md5.convert(
      '${entity.id}|$modified|${original.lengthSync()}'.codeUnits,
    );
    return digest.toString();
  }

  Future<File?> cachedProxy(AssetEntity entity, File original) async {
    final path = await _proxyPath(entity, original);
    final file = File(path);
    if (await file.exists() && await file.length() > 0) return file;
    return null;
  }

  Future<String> _proxyPath(AssetEntity entity, File original) async {
    final root = await _proxyRoot();
    return p.join(root.path, '${_cacheKey(entity, original)}.mp4');
  }

  Future<bool> shouldGenerateProxy(AssetEntity entity, File original) async {
    final duration = entity.duration;
    return HeavyVideoDetector.needsProxy(
      width: entity.width,
      height: entity.height,
      fileSizeBytes: await original.length(),
      durationSeconds: duration > 0 ? (duration / 1000).round() : 0,
    );
  }

  /// Returns cached proxy immediately, or starts background transcode.
  Future<File> resolvePlaybackFile(AssetEntity entity, File original) async {
    final cached = await cachedProxy(entity, original);
    if (cached != null) return cached;

    if (!await shouldGenerateProxy(entity, original)) {
      return original;
    }

    unawaited(ensureProxy(entity, original));
    return original;
  }

  /// Waits for proxy (or returns cached). Original file is read-only input.
  Future<File?> ensureProxy(AssetEntity entity, File original) async {
    final key = _cacheKey(entity, original);
    final existing = _inFlight[key];
    if (existing != null) return existing;

    final future = _transcode(entity, original);
    _inFlight[key] = future;
    try {
      return await future;
    } finally {
      _inFlight.remove(key);
    }
  }

  Future<File?> _transcode(AssetEntity entity, File original) async {
    final cached = await cachedProxy(entity, original);
    if (cached != null) return cached;

    final outputPath = await _proxyPath(entity, original);
    final output = File(outputPath);
    if (await output.exists()) await output.delete();

    // 8-bit H.264 1080p cap — hardware-decodable on virtually all devices.
    final command = [
      '-y',
      '-i',
      _escapePath(original.path),
      '-c:v',
      'libx264',
      '-preset',
      'veryfast',
      '-crf',
      '23',
      '-vf',
      'scale=-2:1080',
      '-pix_fmt',
      'yuv420p',
      '-c:a',
      'aac',
      '-b:a',
      '128k',
      '-movflags',
      '+faststart',
      _escapePath(outputPath),
    ].join(' ');

    if (kDebugMode) {
      debugPrint('VideoProxyService: transcoding ${original.path}');
    }

    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();
    if (!ReturnCode.isSuccess(returnCode)) {
      if (kDebugMode) {
        final logs = await session.getAllLogsAsString();
        debugPrint('VideoProxyService transcode failed: $logs');
      }
      if (await output.exists()) await output.delete();
      return null;
    }

    if (!await output.exists() || await output.length() == 0) {
      return null;
    }

    if (kDebugMode) {
      debugPrint(
        'VideoProxyService: proxy ready '
        '(${await output.length()} bytes, original untouched)',
      );
    }
    return output;
  }

  String _escapePath(String path) {
    if (path.contains(' ')) return '"$path"';
    return path;
  }
}
