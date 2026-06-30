import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/settings/presentation/providers/notification_settings_provider.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settingsAsync = ref.watch(notificationSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: settingsAsync.when(
        data: (settings) {
          final notifier = ref.read(notificationSettingsProvider.notifier);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SwitchListTile(
                title: const Text('Allow Notifications'),
                subtitle: const Text('Enable or disable all app notifications'),
                value: settings.allowNotifications,
                onChanged: (val) {
                  notifier.updateSettings(settings.copyWith(allowNotifications: val));
                },
              ),
              const Divider(),
              if (settings.allowNotifications) ...[
                SwitchListTile(
                  title: const Text('Enable Sounds'),
                  value: settings.enableSounds,
                  onChanged: (val) {
                    notifier.updateSettings(settings.copyWith(enableSounds: val));
                  },
                ),
                SwitchListTile(
                  title: const Text('Enable Vibration'),
                  value: settings.enableVibration,
                  onChanged: (val) {
                    notifier.updateSettings(settings.copyWith(enableVibration: val));
                  },
                ),
                SwitchListTile(
                  title: const Text('Heads Up Notifications'),
                  subtitle: const Text('Show notifications on top of screen'),
                  value: settings.enableHeadsUp,
                  onChanged: (val) {
                    notifier.updateSettings(settings.copyWith(enableHeadsUp: val));
                  },
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Content', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SwitchListTile(
                  title: const Text('Show Description'),
                  value: settings.showDescription,
                  onChanged: (val) {
                    notifier.updateSettings(settings.copyWith(showDescription: val));
                  },
                ),
                SwitchListTile(
                  title: const Text('Show Tag'),
                  value: settings.showTag,
                  onChanged: (val) {
                    notifier.updateSettings(settings.copyWith(showTag: val));
                  },
                ),
                SwitchListTile(
                  title: const Text('Show Priority'),
                  value: settings.showPriority,
                  onChanged: (val) {
                    notifier.updateSettings(settings.copyWith(showPriority: val));
                  },
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Quiet Hours', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SwitchListTile(
                  title: const Text('Enable Quiet Hours'),
                  subtitle: const Text('Mute notifications during this time'),
                  value: settings.quietHoursEnabled,
                  onChanged: (val) {
                    notifier.updateSettings(settings.copyWith(quietHoursEnabled: val));
                  },
                ),
                if (settings.quietHoursEnabled) ...[
                  ListTile(
                    title: const Text('Start Time'),
                    trailing: Text(
                      '${settings.quietHoursStartHour.toString().padLeft(2, '0')}:${settings.quietHoursStartMinute.toString().padLeft(2, '0')}',
                      style: theme.textTheme.bodyLarge,
                    ),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: settings.quietHoursStartHour,
                          minute: settings.quietHoursStartMinute,
                        ),
                      );
                      if (time != null) {
                        notifier.updateSettings(settings.copyWith(
                          quietHoursStartHour: time.hour,
                          quietHoursStartMinute: time.minute,
                        ));
                      }
                    },
                  ),
                  ListTile(
                    title: const Text('End Time'),
                    trailing: Text(
                      '${settings.quietHoursEndHour.toString().padLeft(2, '0')}:${settings.quietHoursEndMinute.toString().padLeft(2, '0')}',
                      style: theme.textTheme.bodyLarge,
                    ),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: settings.quietHoursEndHour,
                          minute: settings.quietHoursEndMinute,
                        ),
                      );
                      if (time != null) {
                        notifier.updateSettings(settings.copyWith(
                          quietHoursEndHour: time.hour,
                          quietHoursEndMinute: time.minute,
                        ));
                      }
                    },
                  ),
                ],
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error loading settings: $e')),
      ),
    );
  }
}
