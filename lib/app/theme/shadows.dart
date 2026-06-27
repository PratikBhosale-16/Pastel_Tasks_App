import 'package:flutter/material.dart';

/// Shadow and elevation tokens for the application shell.
abstract final class AppShadows {
  const AppShadows._();

  /// No elevation.
  static const double none = 0;

  /// Small elevation.
  static const double sm = 2;

  /// Medium elevation.
  static const double md = 4;

  /// Large elevation.
  static const double lg = 8;

  /// Small soft shadow.
  static const List<BoxShadow> softSm = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  /// Medium soft shadow.
  static const List<BoxShadow> softMd = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  /// Large soft shadow.
  static const List<BoxShadow> softLg = [
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];
}
