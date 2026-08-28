import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../../core/services/video_proxy_service.dart';
import '../../domain/models/media_asset.dart';
import 'kuva_video_controls.dart';

/// Fullscreen video with media_kit decode + Chewie-style controls and gestures.
class ProVideoPlayer extends StatefulWidget {
  const ProVideoPlayer({
    super.key,
    required this.asset,
    this.onVideoEnded,
  });

  final MediaAsset asset;
  final VoidCallback? onVideoEnded;

  @override
  State<ProVideoPlayer> createState() => _ProVideoPlayerState();
}

class _ProVideoPlayerState extends State<ProVideoPlayer> {
  Player? _player;
  VideoController? _videoController;
  StreamSubscription<bool>? _completedSub;
  var _error = false;
  var _endedFired = false;
  var _gestureOverlay = '';
  var _usingProxy = false;
  var _preparingProxy = false;
  double _brightness = 0.5;
  double _volume = 0.5;
  Offset? _dragOrigin;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final file = await widget.asset.entity.file;
      if (file == null || !await file.exists()) {
        if (mounted) setState(() => _error = true);
        return;
      }
      final playbackFile = await VideoProxyService.instance.resolvePlaybackFile(
        widget.asset.entity,
        file,
      );

      _player = Player();
      _videoController = VideoController(_player!);
      await _openMedia(playbackFile);

      try {
        _brightness = await ScreenBrightness().current;
        _volume = await FlutterVolumeController.getVolume() ?? 0.5;
      } catch (_) {}

      _completedSub = _player!.stream.completed.listen((completed) {
        if (completed && !_endedFired) {
          _endedFired = true;
          widget.onVideoEnded?.call();
        }
      });

      _maybeUpgradeToProxy(file);

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('ProVideoPlayer init failed: $e');
      if (mounted) setState(() => _error = true);
    }
  }

  Future<void> _openMedia(File file) async {
    final uri = Uri.file(file.path).toString();
    await _player!.open(Media(uri), play: true);
  }

  Future<void> _maybeUpgradeToProxy(File original) async {
    final needsProxy = await VideoProxyService.instance.shouldGenerateProxy(
      widget.asset.entity,
      original,
    );
    if (!needsProxy || !mounted) return;

    final cached = await VideoProxyService.instance.cachedProxy(
      widget.asset.entity,
      original,
    );
    if (cached != null) {
      if (cached.path != original.path) {
        await _switchToFile(cached, isProxy: true);
      }
      return;
    }

    if (mounted) setState(() => _preparingProxy = true);

    final proxy = await VideoProxyService.instance.ensureProxy(
      widget.asset.entity,
      original,
    );
    if (!mounted || proxy == null) {
      if (mounted) setState(() => _preparingProxy = false);
      return;
    }

    await _switchToFile(proxy, isProxy: true);
    if (mounted) setState(() => _preparingProxy = false);
  }

  Future<void> _switchToFile(File file, {required bool isProxy}) async {
    if (_player == null) return;
    final position = _player!.state.position;
    final wasPlaying = _player!.state.playing;
    await _player!.open(Media(Uri.file(file.path).toString()), play: false);
    if (position > Duration.zero) {
      await _player!.seek(position);
    }
    if (wasPlaying) await _player!.play();
    if (mounted) setState(() => _usingProxy = isProxy);
  }

  void _seekRelative(Duration delta) {
    if (_player == null) return;
    final pos = _player!.state.position + delta;
    final max = _player!.state.duration;
    final clamped = pos < Duration.zero
        ? Duration.zero
        : pos > max
            ? max
            : pos;
    _player!.seek(clamped);
    setState(() {
      _gestureOverlay = delta.isNegative ? '-10s' : '+10s';
    });
    Future<void>.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _gestureOverlay = '');
    });
  }

  @override
  void dispose() {
    _completedSub?.cancel();
    _player?.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.videocam_off_outlined, color: Colors.white54, size: 48),
            SizedBox(height: 8),
            Text(
              'Video unavailable',
              style: TextStyle(color: Colors.white54),
            ),
          ],
        ),
      );
    }

    if (_videoController == null || _player == null) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return KuvaVideoControlsTheme(
      child: ColoredBox(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Video(
                controller: _videoController!,
                controls: kuvaVideoControls,
                fill: Colors.black,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.sizeOf(context).height * 0.62,
              child: Row(
                children: [
                  Expanded(child: _buildSideZone(isLeft: true)),
                  const Spacer(flex: 2),
                  Expanded(child: _buildSideZone(isLeft: false)),
                ],
              ),
            ),
            if (_preparingProxy && !_usingProxy)
              Positioned(
                top: MediaQuery.paddingOf(context).top + 56,
                left: 16,
                right: 16,
                child: IgnorePointer(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Preparing smooth preview…',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                ),
              ),
            if (_gestureOverlay.isNotEmpty)
              IgnorePointer(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _gestureOverlay,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideZone({required bool isLeft}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onDoubleTap: () => _seekRelative(
        Duration(seconds: isLeft ? -10 : 10),
      ),
      onVerticalDragStart: (d) => _dragOrigin = d.localPosition,
      onVerticalDragUpdate: (d) async {
        if (_dragOrigin == null) return;
        final delta = (_dragOrigin!.dy - d.localPosition.dy) / 200;
        _dragOrigin = d.localPosition;
        if (isLeft) {
          _volume = (_volume + delta).clamp(0.0, 1.0);
          try {
            await FlutterVolumeController.setVolume(_volume);
          } catch (_) {}
          setState(() {
            _gestureOverlay = 'Volume ${(_volume * 100).round()}%';
          });
        } else {
          _brightness = (_brightness + delta).clamp(0.05, 1.0);
          try {
            await ScreenBrightness().setScreenBrightness(_brightness);
          } catch (_) {}
          setState(() {
            _gestureOverlay = 'Brightness ${(_brightness * 100).round()}%';
          });
        }
      },
      onVerticalDragEnd: (_) {
        _dragOrigin = null;
        Future<void>.delayed(const Duration(milliseconds: 700), () {
          if (mounted) setState(() => _gestureOverlay = '');
        });
      },
      child: const SizedBox.expand(),
    );
  }
}
