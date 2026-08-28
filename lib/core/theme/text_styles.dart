import 'package:flutter/material.dart';

/// Reusable text styles for album cards and secondary labels (#3).
abstract final class AppTextStyles {
  static TextStyle albumName(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          height: 1.2,
        );
  }

  static TextStyle albumMeta(BuildContext context) {
    final base = Theme.of(context).colorScheme.onSurface;
    return Theme.of(context).textTheme.labelSmall!.copyWith(
          fontSize: 11,
          color: base.withValues(alpha: 0.65),
          height: 1.3,
        );
  }
}
