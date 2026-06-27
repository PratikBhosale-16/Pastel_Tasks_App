/// Represents an operation result.
abstract class Result<T> {
  /// Creates an operation result.
  const Result();
}

/// Successful operation result.
final class Success<T> extends Result<T> {
  /// Creates a successful result.
  const Success(this.value);

  /// Result value.
  final T value;
}
