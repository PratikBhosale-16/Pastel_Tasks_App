import 'dart:io';
import 'package:pastel_tasks/features/backup/domain/enums/backup_type.dart';
import 'package:pastel_tasks/features/backup/domain/models/backup_payload.dart';

/// Abstract interface for backup operations.
abstract class BackupRepository {
  /// Initializes the repository if needed (e.g. auth for Google Drive).
  Future<void> initialize();

  /// Creates a backup file and returns its path or reference.
  Future<String> createBackup(BackupPayload payload, {String? password});

  /// Restores a backup payload from a file path or reference.
  Future<BackupPayload> restoreBackup(String reference, {String? password});

  /// Returns a list of available backups (paths or references) with their metadata.
  Future<List<Map<String, dynamic>>> getAvailableBackups();

  /// Deletes a specific backup.
  Future<void> deleteBackup(String reference);

  /// The type of this backup repository.
  BackupType get type;
}
