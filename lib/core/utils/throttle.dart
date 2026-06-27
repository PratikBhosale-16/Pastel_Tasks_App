import 'dart:async';

import 'package:pastel_tasks/core/utils/constants.dart';

/// Limits an action to one execution per configured interval.
final class Throttler {
  /// Creates a throttler.
  Throttler({this.interval = CoreDurations.throttle});

  /// Minimum interval between executions.
  final Duration interval;

  Timer? _timer;

  /// Runs [action] immediately when the throttle window is open.
  void call(void Function() action) {
    if (_timer?.isActive ?? false) {
      return;
    }
    action();
    _timer = Timer(interval, () {});
  }

  /// Opens the throttle window immediately.
  void reset() {
    _timer?.cancel();
    _timer = null;
  }
}
