import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/app_theme.dart';

/// Shimmer skeleton matching tile shape — reads as loading, not stuck (#6).
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({super.key, this.borderRadius});

  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: scheme.surfaceContainerHighest,
      highlightColor: scheme.surfaceContainerLow,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppTheme.tileRadius,
          ),
        ),
      ),
    );
  }
}
