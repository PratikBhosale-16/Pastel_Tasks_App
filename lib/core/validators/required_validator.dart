/// Validates required values.
abstract final class RequiredValidator {
  /// Whether [value] contains a non-blank value.
  static bool isValid(Object? value) {
    return switch (value) {
      null => false,
      final String text => text.trim().isNotEmpty,
      final Iterable<Object?> values => values.isNotEmpty,
      _ => true,
    };
  }
}
