import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'kuva_typography.dart';
import 'spacing.dart';

/// Light/dark Material 3 themes — Kuva brand violet seed, mint accent.
class AppTheme {
  AppTheme._();

  static const cardRadius = 18.0;
  static const tileRadius = 16.0;

  static final ColorScheme _lightScheme = ColorScheme.fromSeed(
    seedColor: KuvaColors.primaryViolet,
    brightness: Brightness.light,
  ).copyWith(
    secondary: KuvaColors.accentMint,
    onSecondary: KuvaColors.nearBlack,
  );

  static final ColorScheme _darkScheme = ColorScheme.fromSeed(
    seedColor: KuvaColors.primaryViolet,
    brightness: Brightness.dark,
  ).copyWith(
    secondary: KuvaColors.accentMint,
    onSecondary: KuvaColors.nearBlack,
    surface: KuvaColors.nearBlack,
  );

  static ThemeData light() => _base(_lightScheme);

  static ThemeData dark() => _base(_darkScheme);

  static ThemeData _base(ColorScheme scheme) {
    final textTheme = KuvaTypography.textTheme(
      ThemeData(brightness: scheme.brightness).textTheme,
      scheme,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: KuvaColors.primaryViolet,
          foregroundColor: KuvaColors.white,
          disabledBackgroundColor:
              KuvaColors.primaryViolet.withValues(alpha: 0.38),
          disabledForegroundColor: KuvaColors.white.withValues(alpha: 0.6),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return KuvaColors.white;
          }
          return scheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return KuvaColors.primaryViolet;
          }
          return scheme.surfaceContainerHighest;
        }),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: KuvaColors.accentMint,
        linearTrackColor: KuvaColors.accentMint.withValues(alpha: 0.2),
        circularTrackColor: KuvaColors.accentMint.withValues(alpha: 0.2),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return KuvaColors.primaryViolet.withValues(alpha: 0.15);
            }
            return null;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return KuvaColors.primaryViolet;
            }
            return scheme.onSurface;
          }),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: KuvaColors.primaryViolet.withValues(alpha: 0.18),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelMedium?.copyWith(
            color: selected ? KuvaColors.primaryViolet : scheme.onSurfaceVariant,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          );
        }),
      ),
      cardTheme: CardThemeData(
        elevation: 3,
        shadowColor: scheme.shadow.withValues(alpha: 0.12),
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  /// Semi-transparent surface for glass overlays.
  static Color glassSurface(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return scheme.surface.withValues(alpha: 0.72);
  }

  static ImageFilter glassBlur() => ImageFilter.blur(sigmaX: 18, sigmaY: 18);
}

/// Computes home album card aspect ratio once per layout pass.
double homeAlbumAspectRatio(double screenWidth) {
  const columns = 3;
  const spacing = AppSpacing.sm;
  const horizontalPadding = AppSpacing.sm * 2;
  const metaHeight = 54.0;
  final cellWidth =
      (screenWidth - horizontalPadding - spacing * (columns - 1)) / columns;
  return cellWidth / (cellWidth + metaHeight);
}
