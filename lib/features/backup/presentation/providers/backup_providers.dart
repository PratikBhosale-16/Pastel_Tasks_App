import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/backup/data/repositories/drive_backup_repository.dart';
import 'package:pastel_tasks/features/backup/data/repositories/local_backup_repository.dart';
import 'package:pastel_tasks/features/backup/data/services/backup_crypto_service.dart';
import 'package:pastel_tasks/features/backup/domain/enums/backup_type.dart';
import 'package:pastel_tasks/features/backup/domain/models/backup_payload.dart';
import 'package:pastel_tasks/features/backup/domain/repositories/backup_repository.dart';
import 'package:pastel_tasks/features/backup/data/mappers/backup_mapper.dart';
import 'package:pastel_tasks/core/providers/core_providers.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/tag_collection.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/task_collection.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/reminder_collection.dart';
import 'package:pastel_tasks/features/settings/presentation/providers/account_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:isar/isar.dart';

final backupCryptoServiceProvider = Provider((ref) => BackupCryptoService());

final localBackupRepositoryProvider = Provider<BackupRepository>((ref) {
  final cryptoService = ref.watch(backupCryptoServiceProvider);
  return LocalBackupRepository(cryptoService);
});

final driveBackupRepositoryProvider = Provider<DriveBackupRepository>((ref) {
  final accountService = ref.watch(accountServiceProvider);
  return DriveBackupRepository(accountService);
});

final backupServiceStateProvider = StateNotifierProvider<BackupServiceNotifier, AsyncValue<void>>((ref) {
  return BackupServiceNotifier(ref);
});

class BackupServiceNotifier extends StateNotifier<AsyncValue<void>> {
  BackupServiceNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<BackupPayload> _createPayload() async {
    final dbService = ref.read(databaseProvider);
    final isar = dbService.instanceOrThrow;
    final prefs = await SharedPreferences.getInstance();

    final tasks = await isar.taskCollections.where().findAll();
    final tags = await isar.tagCollections.where().findAll();
    final reminders = await isar.reminderCollections.where().findAll();

    return BackupMapper.createPayload(
      tasks: tasks,
      tags: tags,
      reminders: reminders,
      prefs: prefs,
    );
  }

  Future<void> _restorePayload(BackupPayload payload, bool merge) async {
    final dbService = ref.read(databaseProvider);
    final isar = dbService.instanceOrThrow;
    final prefs = await SharedPreferences.getInstance();

    await isar.writeTxn(() async {
      if (!merge) {
        await isar.taskCollections.clear();
        await isar.tagCollections.clear();
        await isar.reminderCollections.clear();
        await prefs.clear();
      }

      final tasks = payload.tasksJson.map(BackupMapper.taskCollectionFromJson).toList();
      final tags = payload.tagsJson.map(BackupMapper.tagCollectionFromJson).toList();
      final reminders = payload.remindersJson.map(BackupMapper.reminderCollectionFromJson).toList();

      await isar.taskCollections.putAll(tasks);
      await isar.tagCollections.putAll(tags);
      await isar.reminderCollections.putAll(reminders);
    });

    for (final entry in payload.preferencesJson.entries) {
      final value = entry.value;
      if (value is String) await prefs.setString(entry.key, value);
      if (value is int) await prefs.setInt(entry.key, value);
      if (value is double) await prefs.setDouble(entry.key, value);
      if (value is bool) await prefs.setBool(entry.key, value);
      if (value is List) await prefs.setStringList(entry.key, value.cast<String>());
    }
  }

  Future<void> createBackup({required BackupType type, String? password}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final payload = await _createPayload();
      final repo = type == BackupType.local
          ? ref.read(localBackupRepositoryProvider)
          : ref.read(driveBackupRepositoryProvider);

      if (repo is DriveBackupRepository) {
        if (!repo.isSignedIn) {
          await repo.signIn();
        }
      }

      await repo.createBackup(payload, password: password);
    });
  }

  Future<void> restoreBackup(String reference, {required BackupType type, String? password, bool merge = false}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = type == BackupType.local
          ? ref.read(localBackupRepositoryProvider)
          : ref.read(driveBackupRepositoryProvider);

      final payload = await repo.restoreBackup(reference, password: password);
      await _restorePayload(payload, merge);
    });
  }

  Future<void> deleteBackup(String reference, {required BackupType type}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = type == BackupType.local
          ? ref.read(localBackupRepositoryProvider)
          : ref.read(driveBackupRepositoryProvider);
      await repo.deleteBackup(reference);
    });
  }
}

final availableBackupsProvider = FutureProvider.family<List<Map<String, dynamic>>, BackupType>((ref, type) async {
  final repo = type == BackupType.local
      ? ref.read(localBackupRepositoryProvider)
      : ref.read(driveBackupRepositoryProvider);

  if (repo is DriveBackupRepository) {
    if (!repo.isSignedIn) {
      try {
        await repo.initialize();
      } catch (e) {
        return [];
      }
    }
    if (!repo.isSignedIn) return [];
  }
  
  return repo.getAvailableBackups();
});
