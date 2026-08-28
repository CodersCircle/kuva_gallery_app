import 'package:photo_manager/photo_manager.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/models/album_model.dart';
import '../../domain/models/media_asset.dart';
import '../../domain/models/paged_assets_result.dart';

/// Wrapper around photo_manager for album and asset enumeration.
class PhotoManagerDatasource {
  /// Newest capture first — used for album grid, hide, and prefetch.
  static final _newestFirstFilter = FilterOptionGroup(
    orders: [
      const OrderOption(type: OrderOptionType.createDate, asc: false),
    ],
  );

  static final _modifiedDescFilter = FilterOptionGroup(
    orders: [
      const OrderOption(type: OrderOptionType.updateDate, asc: false),
    ],
  );

  /// Album path sorted newest capture first (public for prefetch).
  static AssetPathEntity sortNewestFirst(AssetPathEntity path) {
    return path.copyWith(filterOption: _newestFirstFilter);
  }

  AssetPathEntity _newestFirst(AssetPathEntity path) => sortNewestFirst(path);

  Future<PermissionState> requestPermission() {
    return PhotoManager.requestPermissionExtend();
  }

  /// Real device folders only — excludes the isAll pseudo-album ("Recent").
  Future<List<AlbumModel>> getAlbums() async {
    final paths = await PhotoManager.getAssetPathList(
      type: RequestType.common,
    );
    final realAlbums = paths.where((p) => !p.isAll).toList();

    final albums = <AlbumModel>[];
    for (final path in realAlbums) {
      final count = await path.assetCountAsync;
      albums.add(
        AlbumModel(
          id: path.id,
          name: path.name,
          assetPath: path,
          assetCount: count,
        ),
      );
    }
    return albums;
  }

  /// Most recent asset update time for "Recently Updated" sort.
  Future<DateTime?> getAlbumLastModified(AssetPathEntity path) async {
    final count = await path.assetCountAsync;
    if (count == 0) return null;
    final sorted = path.copyWith(filterOption: _modifiedDescFilter);
    final page = await sorted.getAssetListRange(start: 0, end: 1);
    if (page.isEmpty) return null;
    return page.first.modifiedDateTime;
  }

  /// Lazily compute total size for an album (cached by caller).
  Future<int> computeAlbumSize(AlbumModel album) async {
    var total = 0;
    final count = album.assetCount;
    const pageSize = AppConstants.assetPageSize;
    for (var start = 0; start < count; start += pageSize) {
      final end = (start + pageSize).clamp(0, count);
      final assets = await album.assetPath.getAssetListRange(
        start: start,
        end: end,
      );
      for (final asset in assets) {
        final file = await asset.file;
        if (file != null) {
          total += await file.length();
        }
      }
    }
    return total;
  }

  /// Paged asset loading for large albums.
  Future<PagedAssetsResult> getAssetsPaged({
    required AssetPathEntity albumPath,
    required String albumId,
    required int page,
    int pageSize = AppConstants.assetPageSize,
  }) async {
    final start = page * pageSize;
    final sortedPath = _newestFirst(albumPath);
    final total = await sortedPath.assetCountAsync;
    if (start >= total) {
      return const PagedAssetsResult(items: [], hasMore: false);
    }

    final end = (start + pageSize).clamp(0, total);
    final entities = await sortedPath.getAssetListRange(start: start, end: end);

    final items = entities
        .map(
          (e) => MediaAsset(
            id: e.id,
            entity: e,
            albumId: albumId,
            isVideo: e.type == AssetType.video,
          ),
        )
        .toList();

    return PagedAssetsResult(
      items: items,
      hasMore: albumPageHasMore(
        total: total,
        start: start,
        pageSize: pageSize,
        fetchedCount: items.length,
      ),
    );
  }

  Future<int> getAssetCount(AssetPathEntity albumPath) {
    return albumPath.assetCountAsync;
  }

  Future<bool> deleteAsset(String assetId) async {
    final result = await PhotoManager.editor.deleteWithIds([assetId]);
    return result.isNotEmpty;
  }

  Future<List<AssetEntity>> getAllAssetsInAlbum(AssetPathEntity path) async {
    final sorted = _newestFirst(path);
    final count = await sorted.assetCountAsync;
    if (count == 0) return [];
    return sorted.getAssetListRange(start: 0, end: count);
  }
}
