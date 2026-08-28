import 'media_asset.dart';

/// One page of album assets plus whether more pages exist.
class PagedAssetsResult {
  const PagedAssetsResult({
    required this.items,
    required this.hasMore,
  });

  final List<MediaAsset> items;
  final bool hasMore;
}

/// Whether another page exists after fetching `[start, end)` from `total` items.
bool albumPageHasMore({
  required int total,
  required int start,
  required int pageSize,
  required int fetchedCount,
}) {
  if (fetchedCount == 0) return false;
  final end = start + fetchedCount;
  return end < total;
}
