import 'package:equatable/equatable.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/domain/models/reminder.dart';

/// Represents a single task entity.
class Task extends Equatable {
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    this.dueDate,
    this.completedAt,
    this.reminder,
    required this.repeatRule,
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

  /// A short description.
  final String description;

  /// Current task status.
  final TaskStatus status;

  /// Priority level.
  final Priority priority;

  /// List of tag IDs associated with this task.
  final List<String> tags;

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
    String? description,
    TaskStatus? status,
    Priority? priority,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueDate,
    DateTime? completedAt,
    Reminder? reminder,
    RepeatRule? repeatRule,
    double? position,
    bool? isPinned,
    bool? isArchived,
    String? color,
    List<String>? attachments,
    String? notes,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      reminder: reminder ?? this.reminder,
      repeatRule: repeatRule ?? this.repeatRule,
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
        description,
        status,
        priority,
        tags,
        createdAt,
        updatedAt,
        dueDate,
        completedAt,
        reminder,
        repeatRule,
        position,
        isPinned,
        isArchived,
        color,
        attachments,
        notes,
      ];
}
