import 'package:pastel_tasks/features/settings/domain/models/notification_settings.dart';
import 'package:pastel_tasks/infrastructure/local_storage/preferences_service.dart';

class NotificationSettingsRepository {
  NotificationSettingsRepository(this._preferencesService);

  final PreferencesService _preferencesService;

  static const _keyAllowNotifications = 'notif_allow';
  static const _keyEnableSounds = 'notif_sounds';
  static const _keyEnableVibration = 'notif_vibration';
  static const _keyEnableHeadsUp = 'notif_heads_up';
  static const _keyShowNote = 'notif_show_desc';
  static const _keyShowTag = 'notif_show_tag';
  static const _keyShowPriority = 'notif_show_priority';
  static const _keyQuietHoursEnabled = 'notif_qh_enabled';
  static const _keyQuietHoursStartHour = 'notif_qh_start_h';
  static const _keyQuietHoursStartMinute = 'notif_qh_start_m';
  static const _keyQuietHoursEndHour = 'notif_qh_end_h';
  static const _keyQuietHoursEndMinute = 'notif_qh_end_m';
  static const _keySoundPreference = 'notif_sound_pref';
  static const _keyVibrationPreference = 'notif_vib_pref';

  Future<NotificationSettings> getSettings() async {
    final allowNotifications = await _preferencesService.read(_keyAllowNotifications) as bool? ?? true;
    final enableSounds = await _preferencesService.read(_keyEnableSounds) as bool? ?? true;
    final enableVibration = await _preferencesService.read(_keyEnableVibration) as bool? ?? true;
    final enableHeadsUp = await _preferencesService.read(_keyEnableHeadsUp) as bool? ?? true;
    final showNote = await _preferencesService.read(_keyShowNote) as bool? ?? true;
    final showTag = await _preferencesService.read(_keyShowTag) as bool? ?? true;
    final showPriority = await _preferencesService.read(_keyShowPriority) as bool? ?? true;
    final quietHoursEnabled = await _preferencesService.read(_keyQuietHoursEnabled) as bool? ?? false;
    final quietHoursStartHour = await _preferencesService.read(_keyQuietHoursStartHour) as int? ?? 22;
    final quietHoursStartMinute = await _preferencesService.read(_keyQuietHoursStartMinute) as int? ?? 0;
    final quietHoursEndHour = await _preferencesService.read(_keyQuietHoursEndHour) as int? ?? 7;
    final quietHoursEndMinute = await _preferencesService.read(_keyQuietHoursEndMinute) as int? ?? 0;
    final soundPreference = await _preferencesService.read(_keySoundPreference) as String? ?? 'default';
    final vibrationPreference = await _preferencesService.read(_keyVibrationPreference) as String? ?? 'medium';

    return NotificationSettings(
      allowNotifications: allowNotifications,
      enableSounds: enableSounds,
      enableVibration: enableVibration,
      enableHeadsUp: enableHeadsUp,
      showNote: showNote,
      showTag: showTag,
      showPriority: showPriority,
      quietHoursEnabled: quietHoursEnabled,
      quietHoursStartHour: quietHoursStartHour,
      quietHoursStartMinute: quietHoursStartMinute,
      quietHoursEndHour: quietHoursEndHour,
      quietHoursEndMinute: quietHoursEndMinute,
      soundPreference: soundPreference,
      vibrationPreference: vibrationPreference,
    );
  }

  Future<void> saveSettings(NotificationSettings settings) async {
    await _preferencesService.write(_keyAllowNotifications, settings.allowNotifications);
    await _preferencesService.write(_keyEnableSounds, settings.enableSounds);
    await _preferencesService.write(_keyEnableVibration, settings.enableVibration);
    await _preferencesService.write(_keyEnableHeadsUp, settings.enableHeadsUp);
    await _preferencesService.write(_keyShowNote, settings.showNote);
    await _preferencesService.write(_keyShowTag, settings.showTag);
    await _preferencesService.write(_keyShowPriority, settings.showPriority);
    await _preferencesService.write(_keyQuietHoursEnabled, settings.quietHoursEnabled);
    await _preferencesService.write(_keyQuietHoursStartHour, settings.quietHoursStartHour);
    await _preferencesService.write(_keyQuietHoursStartMinute, settings.quietHoursStartMinute);
    await _preferencesService.write(_keyQuietHoursEndHour, settings.quietHoursEndHour);
    await _preferencesService.write(_keyQuietHoursEndMinute, settings.quietHoursEndMinute);
    await _preferencesService.write(_keySoundPreference, settings.soundPreference);
    await _preferencesService.write(_keyVibrationPreference, settings.vibrationPreference);
  }
}
