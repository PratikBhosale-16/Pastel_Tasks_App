import 'package:intl/intl.dart';

/// General-purpose display formatting helpers.
abstract final class FormatterHelpers {
  const FormatterHelpers._();

  /// Formats [value] using compact locale-aware notation.
  static String compactNumber(num value, {String? locale}) {
    return NumberFormat.compact(locale: locale).format(value);
  }

  /// Formats [value] using an ICU date pattern.
  static String date(DateTime value, String pattern, {String? locale}) {
    return DateFormat(pattern, locale).format(value);
  }
}
