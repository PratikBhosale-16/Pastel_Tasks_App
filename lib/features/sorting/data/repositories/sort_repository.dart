import 'dart:convert';
import 'package:pastel_tasks/features/sorting/domain/models/sort_preferences.dart';
import 'package:pastel_tasks/infrastructure/local_storage/preferences_service.dart';

/// Repository for saving and loading sort preferences.
class SortRepository {
  /// Creates a [SortRepository].
  SortRepository(this._preferencesService);

  final PreferencesService _preferencesService;
  
  static const _sortPreferencesKey = 'sort_preferences';

  /// Loads the sort preferences from local storage.
  Future<SortPreferences> loadPreferences() async {
    final data = await _preferencesService.read(_sortPreferencesKey);
    if (data != null && data is String) {
      try {
        final json = jsonDecode(data) as Map<String, dynamic>;
        return SortPreferences.fromJson(json);
      } catch (_) {
        // Fallback to default if decoding fails
        return const SortPreferences();
      }
    }
    return const SortPreferences();
  }

  /// Saves the sort preferences to local storage.
  Future<void> savePreferences(SortPreferences preferences) async {
    final json = jsonEncode(preferences.toJson());
    await _preferencesService.write(_sortPreferencesKey, json);
  }
}
