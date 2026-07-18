import 'package:equatable/equatable.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/domain/models/reminder.dart';
import 'package:pastel_tasks/features/tasks/domain/models/sub_task.dart';

/// Represents a single task entity.
class Task extends Equatable {
  const Task({
    required this.id,
    required this.title,
    required this.note,
    required this.status,
    required this.priority,
    required this.tags,
    this.subTasks = const [],
    required this.createdAt,
    required this.updatedAt,
    this.dueDate,
    this.completedAt,
    this.reminder,
    required this.repeatRule,
    this.repeatEndDate,
    this.repeatCount,
    required this.position,
    required this.isPinned,
    required this.isArchived,
    required this.color,
    required this.attachments,
    this.notes,
  });

  /// Unique identifier.
  final String id;

  /// The title of the task.
  final String title;

  /// A short note.
  final String note;

  /// Current task status.
  final TaskStatus status;

  /// Priority level.
  final Priority priority;

  /// List of tag IDs associated with this task.
  final List<String> tags;

  /// List of sub-tasks for this task.
  final List<SubTask> subTasks;

  /// When the task was created.
  final DateTime createdAt;

  /// When the task was last updated.
  final DateTime updatedAt;

  /// Optional due date.
  final DateTime? dueDate;

  /// Optional completion timestamp.
  final DateTime? completedAt;

  /// Optional reminder setup.
  final Reminder? reminder;

  /// Repetition rule.
  final RepeatRule repeatRule;

  /// Optional date when the repetition ends.
  final DateTime? repeatEndDate;

  /// Optional number of repetitions before ending.
  final int? repeatCount;

  /// Order index for manual sorting.
  final double position;

  /// Whether the task is pinned.
  final bool isPinned;

  /// Whether the task is archived.
  final bool isArchived;

  /// Hex string or color value.
  final String color;

  /// List of attachment references (future-ready).
  final List<String> attachments;

  /// Reference to rich text notes data.
  final String? notes;

  Task copyWith({
    String? id,
    String? title,
    String? note,
    TaskStatus? status,
    Priority? priority,
    List<String>? tags,
    List<SubTask>? subTasks,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueDate,
    DateTime? completedAt,
    Reminder? reminder,
    RepeatRule? repeatRule,
    DateTime? repeatEndDate,
    int? repeatCount,
    double? position,
    bool? isPinned,
    bool? isArchived,
    String? color,
    List<String>? attachments,
    String? notes,
    bool clearCompletedAt = false,
    bool clearReminder = false,
    bool clearDueDate = false,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      subTasks: subTasks ?? this.subTasks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
      reminder: clearReminder ? null : (reminder ?? this.reminder),
      repeatRule: repeatRule ?? this.repeatRule,
      repeatEndDate: repeatEndDate ?? this.repeatEndDate,
      repeatCount: repeatCount ?? this.repeatCount,
      position: position ?? this.position,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      color: color ?? this.color,
      attachments: attachments ?? this.attachments,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        note,
        status,
        priority,
        tags,
        subTasks,
        createdAt,
        updatedAt,
        dueDate,
        completedAt,
        reminder,
        repeatRule,
        repeatEndDate,
        repeatCount,
        position,
        isPinned,
        isArchived,
        color,
        attachments,
        notes,
      ];
}
