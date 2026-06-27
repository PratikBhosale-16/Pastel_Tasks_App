import 'package:flutter/material.dart';

/// A theme extension for holding custom design tokens that don't fit perfectly
/// into the standard Material 3 ThemeData.
class PastelThemeExtension extends ThemeExtension<PastelThemeExtension> {
  /// Creates a new [PastelThemeExtension].
  const PastelThemeExtension();

  @override
  PastelThemeExtension copyWith() {
    return const PastelThemeExtension();
  }

  @override
  PastelThemeExtension lerp(
    ThemeExtension<PastelThemeExtension>? other,
    double t,
  ) {
    if (other is! PastelThemeExtension) {
      return this;
    }
    return const PastelThemeExtension();
  }
}
