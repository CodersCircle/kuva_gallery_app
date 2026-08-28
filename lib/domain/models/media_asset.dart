import 'package:photo_manager/photo_manager.dart';

/// Lightweight wrapper around a gallery asset.
class MediaAsset {
  const MediaAsset({
    required this.id,
    required this.entity,
    required this.albumId,
    this.isVideo = false,
    this.sizeBytes,
  });

  final String id;
  final AssetEntity entity;
  final String albumId;
  final bool isVideo;
  final int? sizeBytes;
}
