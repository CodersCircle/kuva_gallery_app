import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Poppins headings + neutral body text for dense lists.
abstract final class KuvaTypography {
  static TextTheme textTheme(TextTheme base, ColorScheme scheme) {
    final poppins = GoogleFonts.poppinsTextTheme(base);
    final body = GoogleFonts.interTextTheme(poppins);

    return body.copyWith(
      displayLarge: poppins.displayLarge?.copyWith(fontWeight: FontWeight.w700),
      displayMedium: poppins.displayMedium?.copyWith(fontWeight: FontWeight.w700),
      displaySmall: poppins.displaySmall?.copyWith(fontWeight: FontWeight.w700),
      headlineLarge: poppins.headlineLarge?.copyWith(fontWeight: FontWeight.w700),
      headlineMedium: poppins.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
      headlineSmall: poppins.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
      titleLarge: poppins.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      titleMedium: poppins.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      titleSmall: poppins.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: scheme.primary,
      ),
      bodyLarge: body.bodyLarge,
      bodyMedium: body.bodyMedium,
      bodySmall: body.bodySmall,
      labelLarge: poppins.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      labelMedium: body.labelMedium,
      labelSmall: body.labelSmall,
    );
  }
}
