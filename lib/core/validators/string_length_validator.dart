/// Validates string length boundaries.
abstract final class StringLengthValidator {
  /// Whether [value] is within the inclusive length boundaries.
  static bool isValid(String value, {int? minimum, int? maximum}) {
    if (minimum != null && value.length < minimum) {
      return false;
    }
    if (maximum != null && value.length > maximum) {
      return false;
    }
    return true;
  }
}
