import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../providers/app_providers.dart';
import 'shimmer_box.dart';

/// Album cover tile — provider-backed so async bytes trigger exactly one rebuild (#Step 1).
class AlbumCoverThumbnail extends ConsumerWidget {
  const AlbumCoverThumbnail({
    super.key,
    required this.albumId,
    required this.albumPath,
    required this.assetCount,
  });

  final String albumId;
  final AssetPathEntity albumPath;
  final int assetCount;

  static const _decodeSize = 200;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (assetCount == 0) {
      return _fallbackIcon(context);
    }

    final coverAsync = ref.watch(albumCoverProvider(albumId));

    // RepaintBoundary stops sibling card repaints during decode (#Step 3).
    return RepaintBoundary(
      child: coverAsync.when(
        loading: () => const ShimmerBox(borderRadius: 0),
        error: (_, __) => _fallbackIcon(context),
        data: (bytes) {
          if (bytes == null || bytes.isEmpty) {
            return _fallbackIcon(context);
          }
          return Image.memory(
            bytes,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            // cacheWidth matches 200px thumb — avoids full-res decode (#Step 3).
            cacheWidth: _decodeSize,
            gaplessPlayback: true,
          );
        },
      ),
    );
  }

  Widget _fallbackIcon(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.photo_album_outlined,
        size: 40,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
      ),
    );
  }
}
