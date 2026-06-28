import 'package:isar/isar.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';

part 'reminder_collection.g.dart';

@collection
class ReminderCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;

  @Index()
  late String taskId;

  @Index()
  late DateTime reminderDate;

  late int notificationId;

  @enumerated
  late RepeatRule repeatType;

  late int repeatInterval;

  late bool isEnabled;
}
