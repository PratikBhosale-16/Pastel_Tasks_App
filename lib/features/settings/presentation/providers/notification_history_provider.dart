import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pastel_tasks/infrastructure/database/isar/collections/notification_history_collection.dart';
import 'package:pastel_tasks/infrastructure/database/isar/database_service.dart';

final notificationHistoryProvider = FutureProvider<List<NotificationHistoryCollection>>((ref) async {
  final isar = DatabaseService.instance.instanceOrThrow;

  return isar.notificationHistoryCollections
      .where()
      .sortByRecordedAtDesc()
      .findAll();
});
