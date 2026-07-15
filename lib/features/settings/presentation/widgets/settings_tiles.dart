import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
    final primaryColor = Theme.of(context).colorScheme.primary;

    return ListTile(
      title: Text(item.title),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      leading: item.icon != null ? Icon(item.icon, color: primaryColor) : null,
      trailing: Theme(
        data: Theme.of(context).copyWith(useMaterial3: false),
        child: Switch(
          value: state.value ?? item.defaultValue,
          activeColor: primaryColor,
          activeTrackColor: primaryColor.withOpacity(0.5),
          onChanged: (val) {
            ref.read(settingSwitchProvider(item).notifier).toggle();
          },
        ),
      ),
      onTap: () {
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
    final primaryColor = Theme.of(context).colorScheme.primary;
    return ListTile(
      title: Text(item.title),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      leading: item.icon != null ? Icon(item.icon, color: primaryColor) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        context.push(item.route);
      },
    );
  }
}

class SettingsActionTile extends ConsumerWidget {
  final SettingsItemAction item;

  const SettingsActionTile({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final color = item.isDestructive ? theme.colorScheme.error : null;
    final iconColor = color ?? theme.colorScheme.primary;
    
    return ListTile(
      title: Text(item.title, style: TextStyle(color: color)),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      leading: item.icon != null ? Icon(item.icon, color: iconColor) : null,
      onTap: () => item.onAction(context, ref),
    );
  }
}

class SettingsColorPickerTile extends ConsumerWidget {
  final SettingsItemColorPicker item;

  const SettingsColorPickerTile({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return ListTile(
      title: Text(item.title),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      leading: item.icon != null ? Icon(item.icon, color: primaryColor) : null,
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
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return ListTile(
      title: Text(item.title),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      leading: item.icon != null ? Icon(item.icon, color: primaryColor) : null,
      trailing: DropdownButton<String>(
        value: state.value ?? (item.defaultValue as String),
        underline: const SizedBox(),
        alignment: AlignmentDirectional.centerEnd,
        isDense: true,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        icon: const Icon(Icons.arrow_drop_down),
        items: (item.options as List<String>).map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            alignment: AlignmentDirectional.centerEnd,
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
    final primaryColor = Theme.of(context).colorScheme.primary;
    return ListTile(
      title: Text(item.title),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      leading: item.icon != null ? Icon(item.icon, color: primaryColor) : null,
      trailing: Text(
        item.valueLabel,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
