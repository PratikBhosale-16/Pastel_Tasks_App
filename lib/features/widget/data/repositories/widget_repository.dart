import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pastel_tasks/features/widget/domain/models/widget_settings.dart';
import 'package:pastel_tasks/core/providers/core_providers.dart';

abstract class WidgetRepository {
  Future<WidgetSettings> getSettings();
  Future<void> saveSettings(WidgetSettings settings);
}

class WidgetRepositoryImpl implements WidgetRepository {
  WidgetRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;
  static const String _settingsKey = 'widget_settings_pref';

  @override
  Future<WidgetSettings> getSettings() async {
    final settingsJson = _prefs.getString(_settingsKey);
    if (settingsJson != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(settingsJson);
        return WidgetSettings.fromJson(decoded);
      } catch (e) {
        return const WidgetSettings();
      }
    }
    return const WidgetSettings();
  }

  @override
  Future<void> saveSettings(WidgetSettings settings) async {
    await _prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
  }
}

final widgetRepositoryProvider = Provider<WidgetRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return WidgetRepositoryImpl(prefs);
});
