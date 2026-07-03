import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/core/providers/core_providers.dart';

enum AppThemeMode {
  system('System Theme'),
  light('Light Theme'),
  dark('Dark Theme');

  final String label;
  const AppThemeMode(this.label);
}

class ThemeModeNotifier extends StateNotifier<AppThemeMode> {
  ThemeModeNotifier(this.ref) : super(AppThemeMode.system) {
    _loadPreference();
  }

  final Ref ref;
  static const _key = 'theme_mode_preference';

  Future<void> _loadPreference() async {
    final prefs = ref.read(preferencesProvider);
    final value = await prefs.read(_key);
    if (value != null) {
      final index = int.tryParse(value.toString());
      if (index != null && index >= 0 && index < AppThemeMode.values.length) {
        state = AppThemeMode.values[index];
      }
    }
  }

  Future<void> updateTheme(AppThemeMode theme) async {
    state = theme;
    final prefs = ref.read(preferencesProvider);
    await prefs.write(_key, theme.index.toString());
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, AppThemeMode>((ref) {
  return ThemeModeNotifier(ref);
});

enum AppAccent {
  lavender('Lavender', Colors.deepPurple),
  blue('Blue', Colors.blue),
  green('Green', Colors.green),
  mint('Mint', Colors.teal),
  orange('Orange', Colors.orange),
  pink('Pink', Colors.pink),
  purple('Purple', Colors.purple),
  red('Red', Colors.red),
  indigo('Indigo', Colors.indigo),
  teal('Teal', Colors.cyan);

  final String label;
  final MaterialColor color;
  
  const AppAccent(this.label, this.color);
}

class AppAccentNotifier extends StateNotifier<AppAccent> {
  AppAccentNotifier(this.ref) : super(AppAccent.lavender) {
    _loadPreference();
  }

  final Ref ref;
  static const _key = 'app_accent_preference';

  Future<void> _loadPreference() async {
    final prefs = ref.read(preferencesProvider);
    final value = await prefs.read(_key);
    if (value != null) {
      final index = int.tryParse(value.toString());
      if (index != null && index >= 0 && index < AppAccent.values.length) {
        state = AppAccent.values[index];
      }
    }
  }

  Future<void> updateAccent(AppAccent accent) async {
    state = accent;
    final prefs = ref.read(preferencesProvider);
    await prefs.write(_key, accent.index.toString());
  }
}

final appAccentProvider = StateNotifierProvider<AppAccentNotifier, AppAccent>((ref) {
  return AppAccentNotifier(ref);
});
