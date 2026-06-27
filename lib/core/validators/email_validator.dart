/// Validates general email address syntax.
abstract final class EmailValidator {
  static final _pattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  /// Whether [value] has a valid email address shape.
  static bool isValid(String value) => _pattern.hasMatch(value.trim());
}
