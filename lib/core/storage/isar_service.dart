import 'package:isar/isar.dart';
import 'package:pastel_tasks/core/errors/app_exception.dart';
import 'package:pastel_tasks/core/logging/app_logger.dart';
import 'package:path_provider/path_provider.dart';

/// Initializes and exposes the root Isar instance.
final class IsarService {
  IsarService._();

  /// Shared Isar service instance.
  static final instance = IsarService._();

  Isar? _isar;

  /// Active Isar instance.
  Isar get instanceOrThrow {
    final isar = _isar;
    if (isar == null) {
      throw const StorageException('Isar has not been initialized.');
    }
    return isar;
  }

  /// Opens Isar without collections for the application shell.
  Future<Isar> initialize() async {
    final existing = _isar;
    if (existing != null) {
      return existing;
    }

    final directory = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      <CollectionSchema<dynamic>>[],
      directory: directory.path,
    );

    _isar = isar;
    appLogger.info('Isar initialized.');
    return isar;
  }
}
