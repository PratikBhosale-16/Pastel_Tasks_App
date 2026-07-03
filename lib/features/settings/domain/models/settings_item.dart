import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsItem extends Equatable {
  final String id;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final List<String> keywords;
  final bool Function()? isVisible;

  const SettingsItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.icon,
    this.keywords = const [],
    this.isVisible,
  });

  @override
  List<Object?> get props => [id, title, subtitle, icon, keywords, isVisible];
}

class SettingsItemSwitch extends SettingsItem {
  final bool defaultValue;
  final String storageKey;

  const SettingsItemSwitch({
    required super.id,
    required super.title,
    super.subtitle,
    super.icon,
    super.keywords,
    super.isVisible,
    required this.defaultValue,
    required this.storageKey,
  });

  @override
  List<Object?> get props => [...super.props, defaultValue, storageKey];
}

class SettingsItemNavigation extends SettingsItem {
  final String route;

  const SettingsItemNavigation({
    required super.id,
    required super.title,
    super.subtitle,
    super.icon,
    super.keywords,
    super.isVisible,
    required this.route,
  });

  @override
  List<Object?> get props => [...super.props, route];
}

class SettingsItemAction extends SettingsItem {
  final VoidCallback onAction;
  final bool isDestructive;

  const SettingsItemAction({
    required super.id,
    required super.title,
    super.subtitle,
    super.icon,
    super.keywords,
    super.isVisible,
    required this.onAction,
    this.isDestructive = false,
  });

  @override
  List<Object?> get props => [...super.props, onAction, isDestructive];
}

class SettingsItemColorPicker extends SettingsItem {
  final String storageKey;
  
  const SettingsItemColorPicker({
    required super.id,
    required super.title,
    super.subtitle,
    super.icon,
    super.keywords,
    super.isVisible,
    required this.storageKey,
  });

  @override
  List<Object?> get props => [...super.props, storageKey];
}

class SettingsItemDropdown<T> extends SettingsItem {
  final T defaultValue;
  final String storageKey;
  final List<T> options;
  final String Function(T) labelBuilder;

  const SettingsItemDropdown({
    required super.id,
    required super.title,
    super.subtitle,
    super.icon,
    super.keywords,
    super.isVisible,
    required this.defaultValue,
    required this.storageKey,
    required this.options,
    required this.labelBuilder,
  });

  @override
  List<Object?> get props => [...super.props, defaultValue, storageKey, options];
}

class SettingsItemInfo extends SettingsItem {
  final String valueLabel;

  const SettingsItemInfo({
    required super.id,
    required super.title,
    super.subtitle,
    super.icon,
    super.keywords,
    super.isVisible,
    required this.valueLabel,
  });

  @override
  List<Object?> get props => [...super.props, valueLabel];
}
