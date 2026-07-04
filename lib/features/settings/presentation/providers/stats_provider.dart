import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/core/providers/core_providers.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/task_collection.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/tag_collection.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:isar/isar.dart';

final databaseStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final dbService = ref.read(databaseProvider);
  final isar = dbService.instanceOrThrow;

  final taskCount = await isar.taskCollections.where().count();
  final completedTaskCount = await isar.taskCollections.filter().statusEqualTo(TaskStatus.completed).count();
  final archivedTaskCount = await isar.taskCollections.filter().statusEqualTo(TaskStatus.archived).count();
  final tagCount = await isar.tagCollections.where().count();
  
  final dbSizeInBytes = await isar.getSize();
  String dbSizeStr = '${(dbSizeInBytes / 1024 / 1024).toStringAsFixed(2)} MB';
  if (dbSizeInBytes < 1024 * 1024) {
    dbSizeStr = '${(dbSizeInBytes / 1024).toStringAsFixed(1)} KB';
  }

  return {
    'taskCount': taskCount,
    'completedCount': completedTaskCount,
    'archiveCount': archivedTaskCount,
    'tagCount': tagCount,
    'dbSize': dbSizeStr,
  };
});
