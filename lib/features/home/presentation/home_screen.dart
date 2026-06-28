import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_notifier.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:pastel_tasks/app/router/route_names.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_notifier.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_providers.dart';
import 'package:pastel_tasks/features/tasks/presentation/widgets/add_task_bottom_sheet/add_task_bottom_sheet.dart';
import 'package:pastel_tasks/features/tasks/presentation/widgets/task_card/task_card.dart';
import 'package:pastel_tasks/shared/widgets/dialogs/confirmation_dialog.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';
import 'package:pastel_tasks/shared/widgets/empty_state/empty_state.dart';
import 'package:uuid/uuid.dart';

/// Primary entry point for the task management application.
class HomeScreen extends ConsumerWidget {
  /// Creates the home screen.
  const HomeScreen({super.key});

  Future<void> _showAddTask(BuildContext context, WidgetRef ref) async {
    final formData = await AddTaskBottomSheet.show(context);
    if (formData == null || !context.mounted) return;

    final now = DateTime.now().toUtc();
    
    Priority parsePriority(String p) {
      switch (p) {
        case 'Low': return Priority.low;
        case 'High': return Priority.high;
        case 'Critical': return Priority.critical;
        case 'Medium':
        default: return Priority.medium;
      }
    }

    RepeatRule parseRepeatRule(String r) {
      switch (r) {
        case 'Daily': return RepeatRule.daily;
        case 'Weekly': return RepeatRule.weekly;
        case 'Monthly': return RepeatRule.monthly;
        case 'None':
        default: return RepeatRule.none;
      }
    }

    final task = Task(
      id: const Uuid().v4(),
      title: formData.title,
      description: formData.description,
      status: TaskStatus.pending,
      priority: parsePriority(formData.priority),
      tags: formData.tag != null ? [formData.tag!] : [],
      createdAt: now,
      updatedAt: now,
      dueDate: formData.dueDate,
      completedAt: null,
      reminder: null,
      repeatRule: parseRepeatRule(formData.repeatRule),
      position: now.millisecondsSinceEpoch.toDouble(),
      isPinned: formData.isPinned,
      isArchived: false,
      color: formData.color?.value.toRadixString(16) ?? '',
      attachments: const [],
    );

    await ref.read(taskNotifierProvider.notifier).create(task);
    if (!context.mounted) return;

    final state = ref.read(taskNotifierProvider);
    if (state.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create task')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task created successfully')),
      );
    }
  }

  Future<void> _editTask(BuildContext context, WidgetRef ref, Task existingTask) async {
    final formData = await AddTaskBottomSheet.show(context, existingTask: existingTask);
    if (formData == null || !context.mounted) return;

    if (formData.isDelete) {
      _confirmAndDeleteTask(context, ref, existingTask);
      return;
    }
    if (formData.isArchive) {
      _archiveTask(context, ref, existingTask);
      return;
    }
    if (formData.isRestore) {
      ref.read(taskNotifierProvider.notifier).restore(existingTask.id);
      return;
    }

    Priority parsePriority(String p) {
      switch (p) {
        case 'Low': return Priority.low;
        case 'High': return Priority.high;
        case 'Critical': return Priority.critical;
        case 'Medium':
        default: return Priority.medium;
      }
    }

    RepeatRule parseRepeatRule(String r) {
      switch (r) {
        case 'Daily': return RepeatRule.daily;
        case 'Weekly': return RepeatRule.weekly;
        case 'Monthly': return RepeatRule.monthly;
        case 'Yearly': return RepeatRule.yearly;
        case 'None':
        default: return RepeatRule.none;
      }
    }

    final updatedTask = existingTask.copyWith(
      title: formData.title,
      description: formData.description,
      priority: parsePriority(formData.priority),
      tags: formData.tag != null ? [formData.tag!] : [],
      updatedAt: DateTime.now().toUtc(),
      dueDate: formData.dueDate,
      repeatRule: parseRepeatRule(formData.repeatRule),
      isPinned: formData.isPinned,
      color: formData.color?.value.toRadixString(16) ?? '',
    );

    await ref.read(taskNotifierProvider.notifier).updateTask(updatedTask);
    if (!context.mounted) return;

    final state = ref.read(taskNotifierProvider);
    if (state.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update task')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task updated successfully')),
      );
    }
  }

  Future<void> _confirmAndDeleteTask(BuildContext context, WidgetRef ref, Task task) async {
    final confirm = await ConfirmationDialog.show(
      context: context,
      title: 'Delete Task',
      message: 'Delete this task?\nThis action cannot be undone after the timeout.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      isDestructive: true,
    );

    if (confirm && context.mounted) {
      final taskCopy = task;
      await ref.read(taskNotifierProvider.notifier).delete(task.id);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Task deleted'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                ref.read(taskNotifierProvider.notifier).create(taskCopy);
              },
            ),
          ),
        );
      }
    }
  }

  Future<void> _archiveTask(BuildContext context, WidgetRef ref, Task task) async {
    final taskCopy = task;
    await ref.read(taskNotifierProvider.notifier).archive(task.id);
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Task archived'),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              ref.read(taskNotifierProvider.notifier).restore(taskCopy.id);
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final taskListAsync = ref.watch(taskListProvider);
    final todayStr = DateFormat.yMMMMd().format(DateTime.now());

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Good morning!',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              todayStr,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.archive_outlined),
            tooltip: 'Archived Tasks',
            onPressed: () {
              context.push(RouteNames.archivePath);
            },
          ),
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Search Tasks',
            onPressed: () {
              // TODO(M3.x): Implement search navigation
            },
          ),
          const SizedBox(width: 8),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: taskListAsync.when(
          data: (tasks) {
            // Check active/completed tasks only since watchAll doesn't filter.
            // But if the user expects all tasks to be shown here, we'll leave it.
            // Wait, if it's the home screen, normally it's active tasks. Let's just use tasks.
            final displayTasks = tasks.where((t) => !t.isArchived).toList();
            if (displayTasks.isEmpty) {
              return EmptyState.taskList(
                key: const ValueKey('empty_state'),
                onPrimaryAction: () => _showAddTask(context, ref),
              );
            }

            return ReorderableListView.builder(
              key: const ValueKey('reorderable_task_list'),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              itemCount: displayTasks.length,
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final tasksCopy = List<Task>.from(displayTasks);
                final task = tasksCopy.removeAt(oldIndex);
                tasksCopy.insert(newIndex, task);
                final orderedIds = tasksCopy.map((t) => t.id).toList();
                ref.read(taskNotifierProvider.notifier).reorder(orderedIds);
              },
              itemBuilder: (context, index) {
                final task = displayTasks[index];
                return Padding(
                  key: ValueKey(task.id),
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TaskCard(
                    task: task,
                    onTap: () => _editTask(context, ref, task),
                    onEdit: () => _editTask(context, ref, task),
                    onArchive: () => _archiveTask(context, ref, task),
                    onDelete: () => _confirmAndDeleteTask(context, ref, task),
                    onMoveUp: index > 0
                        ? () {
                            final tasksCopy = List<Task>.from(displayTasks);
                            final t = tasksCopy.removeAt(index);
                            tasksCopy.insert(index - 1, t);
                            final orderedIds = tasksCopy.map((t) => t.id).toList();
                            ref.read(taskNotifierProvider.notifier).reorder(orderedIds);
                          }
                        : null,
                    onMoveDown: index < displayTasks.length - 1
                        ? () {
                            final tasksCopy = List<Task>.from(displayTasks);
                            final t = tasksCopy.removeAt(index);
                            tasksCopy.insert(index + 1, t);
                            final orderedIds = tasksCopy.map((t) => t.id).toList();
                            ref.read(taskNotifierProvider.notifier).reorder(orderedIds);
                          }
                        : null,
                    onSwipeRight: () {
                        final newStatus = task.status == TaskStatus.completed 
                            ? TaskStatus.pending 
                            : TaskStatus.completed;
                        
                        final updatedTask = task.copyWith(
                          status: newStatus,
                          updatedAt: DateTime.now().toUtc(),
                          completedAt: newStatus == TaskStatus.completed 
                              ? DateTime.now().toUtc() 
                              : null,
                          clearCompletedAt: newStatus != TaskStatus.completed,
                        );
                        
                        ref.read(taskNotifierProvider.notifier).updateTask(updatedTask);

                        if (newStatus == TaskStatus.completed) {
                          SemanticsService.announce('Task completed', ui.TextDirection.ltr);
                        } else {
                          SemanticsService.announce('Task restored', ui.TextDirection.ltr);
                        }
                      },
                  ),
                );
              },
            );
          },
          error: (err, _) => Center(
            child: Text(
              'Failed to load tasks',
              style: TextStyle(color: colorScheme.error),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create Task',
        onPressed: () => _showAddTask(context, ref),
        child: const Icon(Icons.add_rounded),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (idx) {
          // TODO(M3.x): Implement bottom navigation routing
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.inbox_rounded),
            label: 'Inbox',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.tag_rounded),
            label: 'Tags',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

