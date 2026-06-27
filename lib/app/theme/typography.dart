import 'package:flutter/material.dart';

import 'package:pastel_tasks/app/constants/assets.dart';

/// Typography tokens for the application shell.
abstract final class AppTypography {
  const AppTypography._();

  static const String _baseFamily = AppAssets.fontFamily;

  static const _displayStyle = TextStyle(
    fontFamily: _baseFamily,
    fontSize: 34,
    fontWeight: FontWeight.w700, // Bold
  );

  static const _headlineStyle = TextStyle(
    fontFamily: _baseFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600, // SemiBold
  );

  static const _titleStyle = TextStyle(
    fontFamily: _baseFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600, // SemiBold
  );

  static const _subtitleStyle = TextStyle(
    fontFamily: _baseFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500, // Medium
  );

  static const _bodyStyle = TextStyle(
    fontFamily: _baseFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
  );

  static const _captionStyle = TextStyle(
    fontFamily: _baseFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
  );

  static const _smallStyle = TextStyle(
    fontFamily: _baseFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400, // Regular
  );

  /// Creates a text theme with the specified text color.
  static TextTheme _createTextTheme(
    Color textColor,
    Color secondaryTextColor,
    Color disabledTextColor,
  ) {
    return TextTheme(
      displayLarge: _displayStyle.copyWith(color: textColor),
      displayMedium: _displayStyle.copyWith(
        color: textColor,
        fontSize: 32,
      ),
      displaySmall: _displayStyle.copyWith(
        color: textColor,
        fontSize: 30,
      ),
      
      headlineLarge: _headlineStyle.copyWith(color: textColor),
      headlineMedium: _headlineStyle.copyWith(color: textColor, fontSize: 26),
      headlineSmall: _headlineStyle.copyWith(color: textColor, fontSize: 24),
      
      titleLarge: _titleStyle.copyWith(color: textColor),
      titleMedium: _subtitleStyle.copyWith(color: textColor),
      titleSmall: _subtitleStyle.copyWith(
        color: secondaryTextColor,
        fontSize: 16,
      ),
      
      bodyLarge: _bodyStyle.copyWith(color: textColor),
      bodyMedium: _captionStyle.copyWith(color: textColor),
      bodySmall: _smallStyle.copyWith(color: secondaryTextColor),
      
      labelLarge: _captionStyle.copyWith(
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: _smallStyle.copyWith(color: textColor),
      labelSmall: _smallStyle.copyWith(
        color: disabledTextColor,
        fontSize: 10,
      ),
    );
  }

  /// The light text theme.
  static final TextTheme lightTextTheme = _createTextTheme(
    const Color(0xFF222222), // Primary Text
    const Color(0xFF666666), // Secondary Text
    const Color(0xFFAAAAAA), // Disabled Text
  );

  /// The dark text theme.
  static final TextTheme darkTextTheme = _createTextTheme(
    const Color(0xFFF5F5F5), // Primary Text (Dark)
    const Color(0xFFB0B0B0), // Secondary Text (Dark)
    const Color(0xFF666666), // Disabled Text (Dark)
  );
}
