import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:pastel_tasks/features/widget/domain/models/widget_settings.dart';
import 'package:pastel_tasks/features/widget/data/repositories/widget_repository.dart';
import 'package:pastel_tasks/features/widget/providers/widget_sync_service.dart';
import 'dart:convert';

class WidgetSettingsNotifier extends StateNotifier<AsyncValue<WidgetSettings>> {
  WidgetSettingsNotifier(this._repository, this._syncService) : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  final WidgetRepository _repository;
  final WidgetSyncService _syncService;

  Future<void> _loadSettings() async {
    try {
      final settings = await _repository.getSettings();
      state = AsyncValue.data(settings);
      try {
        await HomeWidget.saveWidgetData('widget_settings', jsonEncode(settings.toJson()));
      } catch (_) {}
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateSettings(WidgetSettings newSettings) async {
    state = AsyncValue.data(newSettings);
    await _repository.saveSettings(newSettings);
    try {
      await HomeWidget.saveWidgetData('widget_settings', jsonEncode(newSettings.toJson()));
    } catch (_) {}
    // Sync to Android widget immediately
    await _syncService.syncAllWidgets();
  }
}

final widgetSettingsProvider = StateNotifierProvider<WidgetSettingsNotifier, AsyncValue<WidgetSettings>>((ref) {
  final repository = ref.watch(widgetRepositoryProvider);
  final syncService = ref.watch(widgetSyncServiceProvider);
  return WidgetSettingsNotifier(repository, syncService);
});
