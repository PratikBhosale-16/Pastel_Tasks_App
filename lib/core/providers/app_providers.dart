import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Periodically updates to provide the current date without time.
final currentDateProvider = StreamProvider<DateTime>((ref) {
  // Emit the current date immediately, then update every minute.
  return Stream.periodic(const Duration(minutes: 1), (_) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }).startWith(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
});

extension on Stream<DateTime> {
  Stream<DateTime> startWith(DateTime value) async* {
    yield value;
    yield* this;
  }
}

/// Notifier for application theme mode.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  void updateThemeMode(ThemeMode mode) {
    state = mode;
  }
}

/// Provides the current application theme mode.
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

/// Provides the application configuration details.
final appConfigurationProvider = Provider<Map<String, dynamic>>((ref) {
  return const {};
});
