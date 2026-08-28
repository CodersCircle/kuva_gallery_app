import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/spacing.dart';

/// Frosted app bar — glassmorphism overlay for modern polish (#7).
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlassAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
  });

  final Widget title;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: AppTheme.glassBlur(),
        child: AppBar(
          leading: leading,
          title: title,
          actions: actions,
          backgroundColor: AppTheme.glassSurface(context),
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          titleSpacing: AppSpacing.lg,
        ),
      ),
    );
  }
}
