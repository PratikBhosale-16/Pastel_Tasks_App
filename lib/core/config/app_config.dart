import 'package:pastel_tasks/core/config/build_info.dart';

/// Reusable application configuration.
final class AppConfig {
  /// Creates application configuration.
  const AppConfig({
    required this.applicationName,
    required this.environmentName,
  });

  /// User-facing application name.
  final String applicationName;

  /// Active environment name.
  final String environmentName;

  /// Loads metadata supplied by the current application package.
  Future<BuildInfo> loadBuildInfo() => BuildInfo.load();
}
