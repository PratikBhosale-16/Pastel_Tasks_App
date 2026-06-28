import 'package:shared_preferences/shared_preferences.dart';

/// Stores non-sensitive application preferences.
final class PreferencesService {
  /// Creates a preferences service.
  PreferencesService({Future<SharedPreferences>? preferences})
      : _preferences = preferences ?? SharedPreferences.getInstance();

  final Future<SharedPreferences> _preferences;

  /// Reads a supported preference value for [key].
  Future<Object?> read(String key) async => (await _preferences).get(key);

  /// Writes a supported preference [value] for [key].
  Future<void> write(String key, Object value) async {
    final preferences = await _preferences;
    switch (value) {
      case final bool preferenceValue:
        await preferences.setBool(key, preferenceValue);
      case final double preferenceValue:
        await preferences.setDouble(key, preferenceValue);
      case final int preferenceValue:
        await preferences.setInt(key, preferenceValue);
      case final String preferenceValue:
        await preferences.setString(key, preferenceValue);
      case final List<String> preferenceValue:
        await preferences.setStringList(key, preferenceValue);
      default:
        throw ArgumentError.value(
          value,
          'value',
          'Unsupported preference type',
        );
    }
  }

  /// Deletes the preference for [key].
  Future<void> delete(String key) async {
    await (await _preferences).remove(key);
  }

  /// Deletes all application preferences.
  Future<void> deleteAll() async {
    await (await _preferences).clear();
  }
}
