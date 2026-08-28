import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';

/// Chewie-style Material controls for media_kit (red seek bar, auto-hide).
Widget kuvaVideoControls(VideoState state) {
  return MaterialVideoControls(state);
}

/// Theme matching the previous Chewie progress colors.
class KuvaVideoControlsTheme extends StatelessWidget {
  const KuvaVideoControlsTheme({super.key, required this.child});

  final Widget child;

  static const _played = Colors.redAccent;
  static const _buffered = Colors.white38;

  @override
  Widget build(BuildContext context) {
    const theme = MaterialVideoControlsThemeData(
      seekBarThumbColor: _played,
      seekBarPositionColor: _played,
      seekBarBufferColor: _buffered,
      buttonBarButtonSize: 26,
      buttonBarButtonColor: Colors.white,
    );

    return MaterialVideoControlsTheme(
      normal: theme,
      fullscreen: const MaterialVideoControlsThemeData(
        seekBarThumbColor: _played,
        seekBarPositionColor: _played,
        seekBarBufferColor: _buffered,
        buttonBarButtonSize: 28,
        buttonBarButtonColor: Colors.white,
      ),
      child: child,
    );
  }
}
