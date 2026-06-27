/// Base exception for application-level failures.
class AppException implements Exception {
  /// Creates an application exception.
  const AppException(this.message, {this.cause});

  /// Human-readable error message.
  final String message;

  /// Optional original cause.
  final Object? cause;

  @override
  String toString() => 'AppException(message: $message, cause: $cause)';
}

/// Exception for validation failures.
class ValidationException extends AppException {
  /// Creates a validation exception.
  const ValidationException(super.message, {super.cause});
}

/// Exception for local storage failures.
class StorageException extends AppException {
  /// Creates a storage exception.
  const StorageException(super.message, {super.cause});
}

/// Exception for network failures.
class NetworkException extends AppException {
  /// Creates a network exception.
  const NetworkException(super.message, {super.cause});
}
