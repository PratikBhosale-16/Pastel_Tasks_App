import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/settings/data/repositories/notification_settings_repository.dart';
import 'package:pastel_tasks/features/settings/domain/models/notification_settings.dart';
import 'package:pastel_tasks/infrastructure/local_storage/preferences_service.dart';

final notificationSettingsRepositoryProvider = Provider<NotificationSettingsRepository>((ref) {
  return NotificationSettingsRepository(PreferencesService());
});

final notificationSettingsProvider = StateNotifierProvider<NotificationSettingsNotifier, AsyncValue<NotificationSettings>>((ref) {
  return NotificationSettingsNotifier(ref.watch(notificationSettingsRepositoryProvider));
});

class NotificationSettingsNotifier extends StateNotifier<AsyncValue<NotificationSettings>> {
  NotificationSettingsNotifier(this._repository) : super(const AsyncLoading()) {
    _loadSettings();
  }

  final NotificationSettingsRepository _repository;

  Future<void> _loadSettings() async {
    try {
      final settings = await _repository.getSettings();
      state = AsyncData(settings);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateSettings(NotificationSettings settings) async {
    try {
      await _repository.saveSettings(settings);
      state = AsyncData(settings);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
