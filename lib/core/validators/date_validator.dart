/// Validates date boundaries.
abstract final class DateValidator {
  /// Whether [value] is within the inclusive date boundaries.
  static bool isValid(DateTime value, {DateTime? minimum, DateTime? maximum}) {
    if (minimum != null && value.isBefore(minimum)) {
      return false;
    }
    if (maximum != null && value.isAfter(maximum)) {
      return false;
    }
    return true;
  }
}
