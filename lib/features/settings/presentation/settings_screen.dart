import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/settings/domain/models/settings_item.dart';
import 'package:pastel_tasks/features/settings/presentation/providers/settings_provider.dart';
import 'package:pastel_tasks/features/settings/presentation/providers/settings_providers.dart';
import 'package:pastel_tasks/features/settings/presentation/providers/theme_providers.dart';
import 'package:pastel_tasks/features/settings/presentation/widgets/profile_card.dart';
import 'package:pastel_tasks/features/settings/presentation/widgets/settings_section_header.dart';
import 'package:pastel_tasks/features/settings/presentation/widgets/settings_tiles.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = ref.watch(filteredSettingsSectionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          if (sections.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(
                child: Text('No settings found.'),
              ),
            ),
          ...sections.map((section) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingsSectionHeader(title: section.title),
                Column(
                  children: [
                    for (int i = 0; i < section.items.length; i++)
                      _buildSettingsTile(context, ref, section.items[i]),
                  ],
                ),
              ],
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, WidgetRef ref, SettingsItem item) {
    if (item is SettingsItemSwitch) {
      return SettingsSwitchTile(item: item);
    } else if (item is SettingsItemNavigation) {
      return SettingsNavigationTile(item: item);
    } else if (item is SettingsItemAction) {
      return SettingsActionTile(item: item);
    } else if (item is SettingsItemDropdown<dynamic>) {
      // It's safe to cast to SettingsDropdownTile here since we only use String dropdowns
      // but Dart generics might complain if we don't handle it properly.
      return SettingsDropdownTile(item: item as SettingsItemDropdown<String>);
    } else if (item is SettingsItemInfo) {
      return SettingsInfoTile(item: item);
    } else if (item is SettingsItemColorPicker) {
      // Determine which accent to show based on ID
      if (item.id == 'appearance_accent') {
        final currentAccent = ref.watch(appAccentProvider);
        return ListTile(
          title: Text(item.title),
          subtitle: Text(currentAccent.label),
          leading: item.icon != null ? Icon(item.icon, color: Theme.of(context).colorScheme.primary) : null,
          trailing: _buildColorIndicator(currentAccent.color),
          onTap: () => _showAppAccentColorPicker(context, ref, currentAccent),
        );
      } else {
        final currentAccent = ref.watch(calendarAccentProvider);
        return ListTile(
          title: Text(item.title),
          subtitle: Text(currentAccent.label),
          leading: item.icon != null ? Icon(item.icon, color: Theme.of(context).colorScheme.primary) : null,
          trailing: _buildColorIndicator(currentAccent.color),
          onTap: () => _showCalendarAccentColorPicker(context, ref, currentAccent),
        );
      }
    }
    return const SizedBox.shrink();
  }

  Widget _buildColorIndicator(Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  void _showCalendarAccentColorPicker(BuildContext context, WidgetRef ref, CalendarAccent currentAccent) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: CalendarAccent.values.map((accent) {
              return ListTile(
                leading: _buildColorIndicator(accent.color),
                title: Text(accent.label),
                trailing: accent == currentAccent
                    ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                    : null,
                onTap: () {
                  ref.read(calendarAccentProvider.notifier).updateAccent(accent);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showAppAccentColorPicker(BuildContext context, WidgetRef ref, AppAccent currentAccent) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: AppAccent.values.map((accent) {
                return ListTile(
                  leading: _buildColorIndicator(accent.color),
                  title: Text(accent.label),
                  trailing: accent == currentAccent
                      ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                      : null,
                  onTap: () {
                    ref.read(appAccentProvider.notifier).updateAccent(accent);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
