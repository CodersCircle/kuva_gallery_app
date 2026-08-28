import 'package:flutter/material.dart';

/// Blurred overlay for opt-in per-album locked covers.
class BlurredThumbnail extends StatelessWidget {
  const BlurredThumbnail({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        Container(
          color: Colors.black.withValues(alpha: 0.4),
          child: const Center(
            child: Icon(Icons.lock, color: Colors.white, size: 32),
          ),
        ),
      ],
    );
  }
}
