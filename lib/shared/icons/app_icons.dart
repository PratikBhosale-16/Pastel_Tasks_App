import 'package:flutter/material.dart';

/// Centralized repository for application icons.
///
/// Wraps Material Symbols Rounded to ensure consistent iconography
/// throughout the application. No feature-specific icons should be placed here.
abstract final class AppIcons {
  const AppIcons._();

  /// Search icon.
  static const IconData search = Icons.search_rounded;

  /// Clear or close icon.
  static const IconData close = Icons.close_rounded;

  /// Add icon.
  static const IconData add = Icons.add_rounded;

  /// Back icon.
  static const IconData back = Icons.arrow_back_rounded;

  /// Forward or detail icon.
  static const IconData forward = Icons.arrow_forward_ios_rounded;

  /// Settings icon.
  static const IconData settings = Icons.settings_rounded;

  /// Calendar or date icon.
  static const IconData calendar = Icons.calendar_today_rounded;

  /// Clock or time icon.
  static const IconData time = Icons.access_time_rounded;

  /// Tag or label icon.
  static const IconData tag = Icons.label_outline_rounded;

  /// Filter icon.
  static const IconData filter = Icons.tune_rounded;

  /// Password visibility on.
  static const IconData visibility = Icons.visibility_rounded;

  /// Password visibility off.
  static const IconData visibilityOff = Icons.visibility_off_rounded;

  /// Warning or error alert icon.
  static const IconData warning = Icons.error_outline_rounded;

  /// Information icon.
  static const IconData info = Icons.info_outline_rounded;

  /// Check or success icon.
  static const IconData check = Icons.check_circle_outline_rounded;
  
  /// Menu icon.
  static const IconData menu = Icons.menu_rounded;
}
