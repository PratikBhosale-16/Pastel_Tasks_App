import 'dart:async';

import 'package:pastel_tasks/core/utils/constants.dart';

/// Delays an action until calls stop for a configured duration.
final class Debouncer {
  /// Creates a debouncer.
  Debouncer({this.delay = CoreDurations.debounce});

  /// Delay applied to each call.
  final Duration delay;

  Timer? _timer;

  /// Schedules [action], replacing any previously scheduled action.
  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancels a pending action.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}
