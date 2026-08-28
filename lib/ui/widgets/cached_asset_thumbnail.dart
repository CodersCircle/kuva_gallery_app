import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../core/services/thumbnail_cache_service.dart';
import 'shimmer_box.dart';

/// Grid tile thumbnail with priority queue, backoff retry, cloud-stub icon.
class CachedAssetThumbnail extends StatefulWidget {
  const CachedAssetThumbnail({
    super.key,
    required this.asset,
    required this.columns,
    this.isVideo = false,
  });

  final AssetEntity asset;
  final int columns;
  final bool isVideo;

  @override
  State<CachedAssetThumbnail> createState() => _CachedAssetThumbnailState();
}

class _CachedAssetThumbnailState extends State<CachedAssetThumbnail> {
  late Future<ThumbnailLoadResult> _future;
  var _highPriority = false;

  @override
  void initState() {
    super.initState();
    _future = _loadFuture();
  }

  @override
  void didUpdateWidget(covariant CachedAssetThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset.id != widget.asset.id ||
        oldWidget.columns != widget.columns) {
      _future = _loadFuture();
    }
  }

  Future<ThumbnailLoadResult> _loadFuture({bool forceRefresh = false}) {
    final size = thumbnailSizeForColumns(widget.columns);
    return ThumbnailCacheService.instance.loadThumbnail(
      widget.asset,
      size,
      priority: _highPriority ? ThumbnailPriority.high : ThumbnailPriority.low,
      forceRefresh: forceRefresh,
    );
  }

  void _retry() {
    setState(() => _future = _loadFuture(forceRefresh: true));
  }

  void _onVisibility(VisibilityInfo info) {
    final visible = info.visibleFraction > 0.1;
    if (visible && !_highPriority) {
      _highPriority = true;
      setState(() => _future = _loadFuture(forceRefresh: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final cacheWidth =
        decodeCacheWidthForTile(size.width, widget.columns, dpr);

    return VisibilityDetector(
      key: Key('thumb_${widget.asset.id}'),
      onVisibilityChanged: _onVisibility,
      child: RepaintBoundary(
        child: AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.zero,
            child: FutureBuilder<ThumbnailLoadResult>(
              future: _future,
              builder: (context, snapshot) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildImageArea(context, snapshot, cacheWidth),
                    if (widget.isVideo)
                      const Positioned(
                        right: 4,
                        bottom: 4,
                        child: Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageArea(
    BuildContext context,
    AsyncSnapshot<ThumbnailLoadResult> snapshot,
    int cacheWidth,
  ) {
    if (snapshot.connectionState != ConnectionState.done) {
      return const ShimmerBox(borderRadius: 0);
    }

    final result = snapshot.data;
    if (result?.status == ThumbnailLoadStatus.success &&
        result!.bytes != null &&
        result.bytes!.isNotEmpty) {
      return Image.memory(
        result.bytes!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        gaplessPlayback: true,
        cacheWidth: cacheWidth,
      );
    }

    if (result?.status == ThumbnailLoadStatus.unavailable) {
      return ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.cloud_off_outlined,
          size: 22,
          color: Theme.of(context)
              .colorScheme
              .onSurface
              .withValues(alpha: 0.45),
        ),
      );
    }

    return GestureDetector(
      onTap: _retry,
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.refresh,
          size: 22,
          color: Theme.of(context)
              .colorScheme
              .onSurface
              .withValues(alpha: 0.45),
        ),
      ),
    );
  }
}
