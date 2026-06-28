import 'package:flutter/foundation.dart';
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

  /// Opens Isar for the application shell.
  Future<Isar?> initialize() async {
    final existing = _isar;
    if (existing != null) {
      return existing;
    }

    final collections = <CollectionSchema<dynamic>>[];
    
    if (collections.isEmpty) {
      appLogger.info('Database initialization skipped (no collections yet).');
      return null;
    }

    var dirPath = '';
    if (!kIsWeb) {
      final directory = await getApplicationDocumentsDirectory();
      dirPath = directory.path;
    }

    final isar = await Isar.open(
      collections,
      directory: dirPath,
    );

    _isar = isar;
    appLogger.info('Isar initialized.');
    return isar;
  }
}
