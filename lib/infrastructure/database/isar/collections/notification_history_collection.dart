import 'package:isar/isar.dart';

part 'notification_history_collection.g.dart';

@collection
class NotificationHistoryCollection {
  Id id = Isar.autoIncrement;

  @Index()
  late String taskId;

  late String taskTitle;

  late String taskDescription;

  late DateTime triggerTime;

  @enumerated
  @Index()
  late NotificationStatus status;

  late DateTime recordedAt;
}

enum NotificationStatus {
  missed,
  completed,
  dismissed,
  snoozed,
}
