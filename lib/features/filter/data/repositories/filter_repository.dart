import 'dart:convert';
import 'package:pastel_tasks/features/filter/domain/models/task_filter.dart';
import 'package:pastel_tasks/infrastructure/local_storage/preferences_service.dart';

/// Repository for persisting the active TaskFilter.
class FilterRepository {
  FilterRepository(this._prefs);

  final PreferencesService _prefs;
  static const String _filterKey = 'active_task_filter';

  /// Saves the filter to local storage.
  Future<void> saveFilter(TaskFilter filter) async {
    final jsonString = jsonEncode(filter.toJson());
    await _prefs.write(_filterKey, jsonString);
  }

  /// Loads the filter from local storage.
  Future<TaskFilter> loadFilter() async {
    final jsonString = await _prefs.read(_filterKey) as String?;
    if (jsonString == null) return TaskFilter.empty;

    try {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return TaskFilter.fromJson(jsonMap);
    } catch (e) {
      // Fallback if parsing fails
      return TaskFilter.empty;
    }
  }

  /// Clears the saved filter.
  Future<void> clearFilter() async {
    await _prefs.delete(_filterKey);
  }
}
