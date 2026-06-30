import 'package:equatable/equatable.dart';

class NotificationSettings extends Equatable {
  const NotificationSettings({
    this.allowNotifications = true,
    this.enableSounds = true,
    this.enableVibration = true,
    this.enableHeadsUp = true,
    this.showDescription = true,
    this.showTag = true,
    this.showPriority = true,
    this.quietHoursEnabled = false,
    this.quietHoursStartHour = 22, // 10 PM
    this.quietHoursStartMinute = 0,
    this.quietHoursEndHour = 7, // 7 AM
    this.quietHoursEndMinute = 0,
    this.soundPreference = 'default',
    this.vibrationPreference = 'medium',
  });

  final bool allowNotifications;
  final bool enableSounds;
  final bool enableVibration;
  final bool enableHeadsUp;
  final bool showDescription;
  final bool showTag;
  final bool showPriority;
  final bool quietHoursEnabled;
  final int quietHoursStartHour;
  final int quietHoursStartMinute;
  final int quietHoursEndHour;
  final int quietHoursEndMinute;
  final String soundPreference;
  final String vibrationPreference;

  NotificationSettings copyWith({
    bool? allowNotifications,
    bool? enableSounds,
    bool? enableVibration,
    bool? enableHeadsUp,
    bool? showDescription,
    bool? showTag,
    bool? showPriority,
    bool? quietHoursEnabled,
    int? quietHoursStartHour,
    int? quietHoursStartMinute,
    int? quietHoursEndHour,
    int? quietHoursEndMinute,
    String? soundPreference,
    String? vibrationPreference,
  }) {
    return NotificationSettings(
      allowNotifications: allowNotifications ?? this.allowNotifications,
      enableSounds: enableSounds ?? this.enableSounds,
      enableVibration: enableVibration ?? this.enableVibration,
      enableHeadsUp: enableHeadsUp ?? this.enableHeadsUp,
      showDescription: showDescription ?? this.showDescription,
      showTag: showTag ?? this.showTag,
      showPriority: showPriority ?? this.showPriority,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStartHour: quietHoursStartHour ?? this.quietHoursStartHour,
      quietHoursStartMinute: quietHoursStartMinute ?? this.quietHoursStartMinute,
      quietHoursEndHour: quietHoursEndHour ?? this.quietHoursEndHour,
      quietHoursEndMinute: quietHoursEndMinute ?? this.quietHoursEndMinute,
      soundPreference: soundPreference ?? this.soundPreference,
      vibrationPreference: vibrationPreference ?? this.vibrationPreference,
    );
  }

  @override
  List<Object?> get props => [
        allowNotifications,
        enableSounds,
        enableVibration,
        enableHeadsUp,
        showDescription,
        showTag,
        showPriority,
        quietHoursEnabled,
        quietHoursStartHour,
        quietHoursStartMinute,
        quietHoursEndHour,
        quietHoursEndMinute,
        soundPreference,
        vibrationPreference,
      ];
}
