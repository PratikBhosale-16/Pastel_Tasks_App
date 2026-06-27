import 'package:flutter/foundation.dart';

/// Compile-time application environment information.
abstract final class AppEnvironment {
  const AppEnvironment._();

  /// Current environment name.
  static const String name = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  /// Whether the app is running in debug mode.
  static const bool isDebug = kDebugMode;

  /// Whether the app is running in profile mode.
  static const bool isProfile = kProfileMode;

  /// Whether the app is running in release mode.
  static const bool isRelease = kReleaseMode;
}
