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
  static const Color backgroundLight = Color(0xFFFFFFFF);

  /// Light theme surface.
  static const Color surfaceLight = Color(0xFFFFFFFF);

  /// Dark theme background.
  static const Color backgroundDark = Color(0xFF121212);

  /// Dark theme surface.
  static const Color surfaceDark = Color(0xFF1E1E1E);

  /// Extended pastel palette for tasks and tags.
  static const List<Color> taskColors = [
    Color(0xFFB8A8FF), // Lavender
    Color(0xFFA8E6CF), // Mint
    Color(0xFF81D4FA), // Sky Blue
    Color(0xFFFFD3B6), // Peach
    Color(0xFFFFF59D), // Yellow
    Color(0xFFF48FB1), // Rose
    Color(0xFF80CBC4), // Teal
    Color(0xFFCE93D8), // Purple
    Color(0xFFFFAB91), // Coral
    Color(0xFFFFF9C4), // Cream
    Color(0xFFC5E1A5), // Olive
    Color(0xFFE0E0E0), // Grey
    Color(0xFFF8BBD0), // Soft Pink
    Color(0xFFFFCC80), // Soft Orange
    Color(0xFFC8E6C9), // Light Green
    Color(0xFFB3E5FC), // Powder Blue
    Color(0xFFE1BEE7), // Lilac
    Color(0xFFFFE0B2), // Apricot
    Color(0xFFB2DFDB), // Aqua
    Color(0xFFD7CCC8), // Mocha
  ];
}
