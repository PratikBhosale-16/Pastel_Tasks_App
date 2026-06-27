import 'package:flutter/material.dart';

/// Color tokens for the application shell.
abstract final class AppColors {
  const AppColors._();

  /// Primary color token.
  static const Color primary = Color(0xFFB8A8FF);

  /// Secondary color token.
  static const Color secondary = Color(0xFFA8E6CF);

  /// Tertiary color token.
  static const Color tertiary = Color(0xFFFFD3B6);

  /// Success color token.
  static const Color success = Color(0xFFA5D6A7);

  /// Warning color token.
  static const Color warning = Color(0xFFFFE082);

  /// Error color token.
  static const Color error = Color(0xFFEF9A9A);

  /// Info color token.
  static const Color info = Color(0xFF81D4FA);

  /// Light theme background.
  static const Color backgroundLight = Color(0xFFFAFAF8);

  /// Light theme surface.
  static const Color surfaceLight = Color(0xFFFFFFFF);

  /// Dark theme background.
  static const Color backgroundDark = Color(0xFF121212);

  /// Dark theme surface.
  static const Color surfaceDark = Color(0xFF1E1E1E);
}
