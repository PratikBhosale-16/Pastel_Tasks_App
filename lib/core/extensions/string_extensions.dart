/// General-purpose string helpers.
extension StringExtensions on String {
  /// Whether the string contains only whitespace.
  bool get isBlank => trim().isEmpty;

  /// Returns null for blank text, otherwise the trimmed value.
  String? get nullIfBlank => isBlank ? null : trim();

  /// Returns the string with its first character capitalized.
  String get capitalized {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
