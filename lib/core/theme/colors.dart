import 'package:flutter/material.dart';

/// Brand palette sampled from [assets/images/kuva_logo.png].
class KuvaColors {
  KuvaColors._();

  /// Main brand purple — dominant "KUVA" violet from logo (#7C4DFF).
  static const primaryViolet = Color(0xFF7C4DFF);

  /// Secondary accent green — "Gallery" / V-segment mint (#00E676).
  static const accentMint = Color(0xFF00E676);

  static const white = Color(0xFFFFFFFF);

  /// Dark-mode surfaces / high-contrast text.
  static const nearBlack = Color(0xFF1A1A2E);

  /// Locked-album tile tint (~6% violet on white).
  static Color lockedTileTint(Brightness brightness) {
    return primaryViolet.withValues(
      alpha: brightness == Brightness.dark ? 0.14 : 0.06,
    );
  }
}
