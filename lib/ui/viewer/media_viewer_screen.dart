import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:photo_view/photo_view.dart';

import '../../core/services/share_service.dart';
import '../../domain/models/media_asset.dart';
import '../../providers/app_providers.dart';
import 'pro_video_player.dart';

/// Full-screen photo/video viewer — PageView so video controls receive touches.
class MediaViewerScreen extends ConsumerStatefulWidget {
  const MediaViewerScreen({
    super.key,
    required this.assets,
    this.initialIndex = 0,
  });

  final List<MediaAsset> assets;
  final int initialIndex;

  @override
  ConsumerState<MediaViewerScreen> createState() => _MediaViewerScreenState();
}

class _MediaViewerScreenState extends ConsumerState<MediaViewerScreen> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onVideoEnded() {
    final autoPlay = ref.read(autoPlayNextVideoProvider);
    if (!autoPlay) return;

    for (var i = _currentIndex + 1; i < widget.assets.length; i++) {
      if (widget.assets[i].isVideo) {
        _pageController.animateToPage(
          i,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        return;
      }
    }
  }

  Future<void> _shareCurrent() async {
    final asset = widget.assets[_currentIndex];
    await ShareService.instance.shareAssets(
      [asset.entity],
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        foregroundColor: Colors.white,
        title: Text('${_currentIndex + 1} / ${widget.assets.length}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share',
            onPressed: _shareCurrent,
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.assets.length,
        onPageChanged: (i) => setState(() => _currentIndex = i),
        itemBuilder: (context, index) {
          final asset = widget.assets[index];
          if (asset.isVideo) {
            return ProVideoPlayer(
              key: ValueKey(asset.id),
              asset: asset,
              onVideoEnded:
                  index == _currentIndex ? _onVideoEnded : null,
            );
          }
          return PhotoView(
            imageProvider: AssetEntityImageProvider(
              asset.entity,
              isOriginal: true,
            ),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * 0.5,
            maxScale: PhotoViewComputedScale.covered * 3,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
          );
        },
      ),
    );
  }
}
