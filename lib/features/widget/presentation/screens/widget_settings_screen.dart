import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/widget/presentation/providers/widget_settings_provider.dart';
import 'package:pastel_tasks/shared/layout/app_shell_scaffold.dart';

class WidgetSettingsScreen extends ConsumerWidget {
  const WidgetSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(widgetSettingsProvider);
    final theme = Theme.of(context);

    return AppShellScaffold(
      title: 'Widget Settings',
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (settings) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text('Content', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary)),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Show Completed Tasks'),
                value: settings.showCompleted,
                onChanged: (val) {
                  ref.read(widgetSettingsProvider.notifier).updateSettings(settings.copyWith(showCompleted: val));
                },
              ),
              SwitchListTile(
                title: const Text('Show Upcoming Tasks'),
                value: settings.showUpcoming,
                onChanged: (val) {
                  ref.read(widgetSettingsProvider.notifier).updateSettings(settings.copyWith(showUpcoming: val));
                },
              ),
              SwitchListTile(
                title: const Text('Show Greeting'),
                value: settings.showGreeting,
                onChanged: (val) {
                  ref.read(widgetSettingsProvider.notifier).updateSettings(settings.copyWith(showGreeting: val));
                },
              ),
              SwitchListTile(
                title: const Text('Show Progress Ring'),
                value: settings.showProgress,
                onChanged: (val) {
                  ref.read(widgetSettingsProvider.notifier).updateSettings(settings.copyWith(showProgress: val));
                },
              ),
              const Divider(),
              Text('Appearance', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary)),
              const SizedBox(height: 8),
              ListTile(
                title: const Text('Background Transparency'),
                subtitle: Slider(
                  value: settings.transparency,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: '${(settings.transparency * 100).toInt()}%',
                  onChanged: (val) {
                    ref.read(widgetSettingsProvider.notifier).updateSettings(settings.copyWith(transparency: val));
                  },
                ),
              ),
              ListTile(
                title: const Text('Corner Radius'),
                subtitle: Slider(
                  value: settings.cornerRadius,
                  min: 0.0,
                  max: 32.0,
                  divisions: 8,
                  label: '${settings.cornerRadius.toInt()}dp',
                  onChanged: (val) {
                    ref.read(widgetSettingsProvider.notifier).updateSettings(settings.copyWith(cornerRadius: val));
                  },
                ),
              ),
              SwitchListTile(
                title: const Text('Compact Mode'),
                subtitle: const Text('Reduces padding for more content'),
                value: settings.compactMode,
                onChanged: (val) {
                  ref.read(widgetSettingsProvider.notifier).updateSettings(settings.copyWith(compactMode: val));
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
