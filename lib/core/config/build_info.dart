import 'package:package_info_plus/package_info_plus.dart';

/// Application package metadata.
final class BuildInfo {
  /// Creates package metadata.
  const BuildInfo({
    required this.version,
    required this.buildNumber,
    required this.packageName,
  });

  /// User-facing application version.
  final String version;

  /// Platform build number.
  final String buildNumber;

  /// Platform package identifier.
  final String packageName;

  /// Combined version and build number.
  String get displayVersion => '$version+$buildNumber';

  /// Loads metadata for the current application package.
  static Future<BuildInfo> load() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return BuildInfo(
      version: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
      packageName: packageInfo.packageName,
    );
  }
}
