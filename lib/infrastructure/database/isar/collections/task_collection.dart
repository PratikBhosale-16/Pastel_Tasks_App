import 'package:isar/isar.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';

part 'task_collection.g.dart';

@collection
class TaskCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;

  late String title;

  @Name('description')
  late String note;

  List<String> tags = [];

  List<String> attachments = [];

  String? richText;

  List<SubTaskCollection> subTasks = [];

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
  late double position;

  @enumerated
  @Index()
  late RepeatRule repeatRule;

  @Index()
  DateTime? repeatEndDate;

  int? repeatCount;

  late String color;

  int? estimatedMinutes;

  @Index()
  DateTime? completedAt;
}

@embedded
class SubTaskCollection {
  late String uuid;
  late String title;
  bool isCompleted = false;
}
