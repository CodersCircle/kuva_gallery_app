import 'package:photo_manager/photo_manager.dart';

/// Domain model wrapping a device album/folder from MediaStore.
class AlbumModel {
  const AlbumModel({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.assetCount,
    this.coverAsset,
    this.totalSizeBytes,
    this.lastModified,
  });

  final String id;
  final String name;
  final AssetPathEntity assetPath;
  final int assetCount;
  final AssetEntity? coverAsset;
  final int? totalSizeBytes;
  final DateTime? lastModified;

  AlbumModel copyWith({
    String? id,
    String? name,
    AssetPathEntity? assetPath,
    int? assetCount,
    AssetEntity? coverAsset,
    int? totalSizeBytes,
    DateTime? lastModified,
  }) {
    return AlbumModel(
      id: id ?? this.id,
      name: name ?? this.name,
      assetPath: assetPath ?? this.assetPath,
      assetCount: assetCount ?? this.assetCount,
      coverAsset: coverAsset ?? this.coverAsset,
      totalSizeBytes: totalSizeBytes ?? this.totalSizeBytes,
      lastModified: lastModified ?? this.lastModified,
    );
  }
}
