import 'package:pastel_tasks/core/errors/app_exception.dart';
import 'package:pastel_tasks/core/result/result.dart';

/// Failed operation result.
sealed class Failure<T> extends Result<T> {
  /// Creates a failed result.
  const Failure(this.exception);

  /// Failure reason.
  final AppException exception;
}

/// Failed validation result.
final class ValidationFailure<T> extends Failure<T> {
  /// Creates a validation failure.
  const ValidationFailure(ValidationException super.exception);
}

/// Failed storage result.
final class StorageFailure<T> extends Failure<T> {
  /// Creates a storage failure.
  const StorageFailure(StorageException super.exception);
}

/// Failed network result.
final class NetworkFailure<T> extends Failure<T> {
  /// Creates a network failure.
  const NetworkFailure(NetworkException super.exception);
}

/// Failed result without a more specific category.
final class UnknownFailure<T> extends Failure<T> {
  /// Creates an unknown failure.
  const UnknownFailure(super.exception);
}
