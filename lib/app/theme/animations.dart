import 'package:flutter/animation.dart';

/// Animation tokens for the application shell.
abstract final class AppAnimations {
  const AppAnimations._();

  /// Fast animation duration (150ms).
  static const Duration fast = Duration(milliseconds: 150);

  /// Normal animation duration (250ms).
  static const Duration normal = Duration(milliseconds: 250);

  /// Slow animation duration (350ms).
  static const Duration slow = Duration(milliseconds: 350);

  /// Default curve.
  static const Curve curveDefault = Curves.easeInOut;

  /// Emphasized curve.
  static const Curve curveEmphasized = Curves.fastOutSlowIn;
}
