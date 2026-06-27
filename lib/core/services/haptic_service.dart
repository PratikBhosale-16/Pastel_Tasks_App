import 'package:flutter/services.dart';

/// Provides application haptic feedback.
final class HapticService {
  /// Triggers light impact feedback.
  Future<void> lightImpact() => HapticFeedback.lightImpact();

  /// Triggers medium impact feedback.
  Future<void> mediumImpact() => HapticFeedback.mediumImpact();

  /// Triggers heavy impact feedback.
  Future<void> heavyImpact() => HapticFeedback.heavyImpact();

  /// Triggers selection feedback.
  Future<void> selectionClick() => HapticFeedback.selectionClick();
}
