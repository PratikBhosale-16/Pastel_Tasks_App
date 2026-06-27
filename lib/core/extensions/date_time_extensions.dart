/// General-purpose date helpers.
extension DateTimeExtensions on DateTime {
  /// Date without a time component.
  DateTime get dateOnly => DateTime(year, month, day);

  /// Whether this value and [other] occur on the same calendar day.
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
