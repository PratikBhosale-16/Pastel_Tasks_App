import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/core/providers/core_providers.dart';

enum CalendarAccent {
  lavender('Lavender', Colors.deepPurple),
  skyBlue('Sky Blue', Colors.lightBlue),
  mint('Mint', Colors.teal),
  orange('Orange', Colors.orange),
  pink('Pink', Colors.pink),
  indigo('Indigo', Colors.indigo),
  emerald('Emerald', Colors.green);

  final String label;
  final MaterialColor color;

  const CalendarAccent(this.label, this.color);
}

class CalendarAccentNotifier extends StateNotifier<CalendarAccent> {
  CalendarAccentNotifier(this.ref) : super(CalendarAccent.lavender) {
    _loadPreference();
  }

  final Ref ref;
  static const _key = 'calendar_accent_color';

  Future<void> _loadPreference() async {
    final prefs = ref.read(preferencesProvider);
    final value = await prefs.read(_key);
    if (value != null) {
      final index = int.tryParse(value.toString());
      if (index != null && index >= 0 && index < CalendarAccent.values.length) {
        state = CalendarAccent.values[index];
      }
    }
  }

  Future<void> updateAccent(CalendarAccent accent) async {
    state = accent;
    final prefs = ref.read(preferencesProvider);
    await prefs.write(_key, accent.index.toString());
  }
}

final calendarAccentProvider =
    StateNotifierProvider<CalendarAccentNotifier, CalendarAccent>((ref) {
  return CalendarAccentNotifier(ref);
});
