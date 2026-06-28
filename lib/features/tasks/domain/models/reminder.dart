import 'package:equatable/equatable.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';

/// Represents a reminder scheduled for a specific task.
class Reminder extends Equatable {
  const Reminder({
    required this.id,
    required this.taskId,
    required this.triggerTime,
    required this.repeatRule,
    required this.enabled,
  });

  /// Unique identifier for the reminder.
  final String id;

  /// The ID of the task this reminder belongs to.
  final String taskId;

  /// When the reminder should trigger.
  final DateTime triggerTime;

  /// How often the reminder repeats.
  final RepeatRule repeatRule;

  /// Whether the reminder is active.
  final bool enabled;

  Reminder copyWith({
    String? id,
    String? taskId,
    DateTime? triggerTime,
    RepeatRule? repeatRule,
    bool? enabled,
  }) {
    return Reminder(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      triggerTime: triggerTime ?? this.triggerTime,
      repeatRule: repeatRule ?? this.repeatRule,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  List<Object?> get props => [id, taskId, triggerTime, repeatRule, enabled];
}
