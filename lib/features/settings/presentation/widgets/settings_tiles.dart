import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pastel_tasks/features/settings/domain/models/settings_item.dart';
import 'package:pastel_tasks/features/settings/presentation/providers/settings_provider.dart';

class SettingsSwitchTile extends ConsumerWidget {
  final SettingsItemSwitch item;

  const SettingsSwitchTile({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingSwitchProvider(item));

    return SwitchListTile(
      title: Text(item.title),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      secondary: item.icon != null ? Icon(item.icon) : null,
      value: state.value ?? item.defaultValue,
      onChanged: (val) {
        ref.read(settingSwitchProvider(item).notifier).toggle();
      },
    );
  }
}

class SettingsNavigationTile extends StatelessWidget {
  final SettingsItemNavigation item;

  const SettingsNavigationTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      leading: item.icon != null ? Icon(item.icon) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        context.push(item.route);
      },
    );
  }
}

class SettingsActionTile extends StatelessWidget {
  final SettingsItemAction item;

  const SettingsActionTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final color = item.isDestructive ? Theme.of(context).colorScheme.error : null;
    return ListTile(
      title: Text(item.title, style: TextStyle(color: color)),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      leading: item.icon != null ? Icon(item.icon, color: color) : null,
      onTap: item.onAction,
    );
  }
}

class SettingsColorPickerTile extends ConsumerWidget {
  final SettingsItemColorPicker item;

  const SettingsColorPickerTile({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(item.title),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      leading: item.icon != null ? Icon(item.icon) : null,
      trailing: const Icon(Icons.color_lens),
      onTap: () {
        // Fallback action, should ideally be injected or handled via provider
      },
    );
  }
}

class SettingsDropdownTile<T> extends ConsumerWidget {
  final SettingsItemDropdown<T> item;

  const SettingsDropdownTile({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We only have String implementation in the provider currently, so we cast it.
    // If we need other types, we could make the provider generic.
    final state = ref.watch(settingDropdownProvider(item as SettingsItemDropdown<String>));
    
    return ListTile(
      title: Text(item.title),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      leading: item.icon != null ? Icon(item.icon) : null,
      trailing: DropdownButton<String>(
        value: state.value ?? (item.defaultValue as String),
        underline: const SizedBox(),
        items: (item.options as List<String>).map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text((item.labelBuilder as String Function(String))(value)),
          );
        }).toList(),
        onChanged: (newValue) {
          if (newValue != null) {
            ref.read(settingDropdownProvider(item as SettingsItemDropdown<String>).notifier).updateValue(newValue);
          }
        },
      ),
    );
  }
}

class SettingsInfoTile extends StatelessWidget {
  final SettingsItemInfo item;

  const SettingsInfoTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      leading: item.icon != null ? Icon(item.icon) : null,
      trailing: Text(
        item.valueLabel,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
