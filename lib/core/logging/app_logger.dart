import 'package:logger/logger.dart';
import 'package:pastel_tasks/core/config/environment.dart';

/// Single global logger service for the application.
final AppLogger appLogger = AppLogger.instance;

/// Application logger wrapper.
final class AppLogger {
  AppLogger._()
      : _logger = Logger(
          level: AppEnvironment.isRelease ? Level.warning : Level.trace,
          printer: PrettyPrinter(methodCount: 0),
        );

  /// Shared logger instance.
  static final instance = AppLogger._();

  final Logger _logger;

  /// Initializes logging for the application process.
  void initialize() {
    _logger.i('Logger initialized.');
  }

  /// Writes a debug log entry.
  void debug(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Writes an informational log entry.
  void info(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Writes a warning log entry.
  void warning(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Writes an error log entry.
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Handles uncaught zone errors.
  void logZoneError(Object error, StackTrace stackTrace) {
    this.error(
      'Uncaught application error.',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
