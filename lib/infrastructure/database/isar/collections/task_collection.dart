import 'package:isar/isar.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';

part 'task_collection.g.dart';

@collection
class TaskCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;

  late String title;

  late String description;

  String? richText;

  @enumerated
  @Index()
  late Priority priority;

  @enumerated
  @Index()
  late TaskStatus status;

  late DateTime createdAt;

  late DateTime updatedAt;

  @Index()
  DateTime? dueDate;

  int? reminderId;

  late bool isPinned;

  late bool isArchived;

  @Index()
  late double orderIndex;

  late String color;

  int? estimatedMinutes;

  @Index()
  DateTime? completedAt;
}
