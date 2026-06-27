import 'package:intl/intl.dart';

/// Centralized date and time operations.
final class DateTimeService {
  /// Creates a date and time service.
  DateTimeService({DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;

  /// Current local date and time.
  DateTime get now => _clock();

  /// Current UTC date and time.
  DateTime get nowUtc => now.toUtc();

  /// Formats [value] with an ICU date pattern.
  String format(DateTime value, String pattern, {String? locale}) {
    return DateFormat(pattern, locale).format(value);
  }

  /// Whether [value] occurs before the current instant.
  bool isPast(DateTime value) => value.isBefore(now);

  /// Whether [value] occurs after the current instant.
  bool isFuture(DateTime value) => value.isAfter(now);

  /// Duration from the current instant to [value].
  Duration until(DateTime value) => value.difference(now);

  /// Duration from [value] to the current instant.
  Duration since(DateTime value) => now.difference(value);
}
