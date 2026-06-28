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
      final messenger = ScaffoldMessenger.of(context);
      final themeContext = Theme.of(context);
      
      await ref.read(taskNotifierProvider.notifier).delete(task.id);
      
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Text('Task deleted'),
              const Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: themeContext.colorScheme.inversePrimary,
                ),
                onPressed: () {
                  messenger.hideCurrentSnackBar();
                  ref.read(taskNotifierProvider.notifier).create(taskCopy);
                },
                child: const Text('UNDO'),
              ),
            ],
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _archiveTask(BuildContext context, WidgetRef ref, Task task) async {
    final taskCopy = task;
    final messenger = ScaffoldMessenger.of(context);
    final themeContext = Theme.of(context);

    await ref.read(taskNotifierProvider.notifier).archive(task.id);
    
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Text('Task archived'),
            const Spacer(),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: themeContext.colorScheme.inversePrimary,
              ),
              onPressed: () {
                messenger.hideCurrentSnackBar();
                ref.read(taskNotifierProvider.notifier).restore(taskCopy.id);
              },
              child: const Text('UNDO'),
            ),
          ],
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, WidgetRef ref, Task task) {
    return TaskCard(
      task: task,
      onTap: () => _editTask(context, ref, task),
      onEdit: () => _editTask(context, ref, task),
      onArchive: () => _archiveTask(context, ref, task),
      onDelete: () => _confirmAndDeleteTask(context, ref, task),
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
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good evening';
    } else {
      return 'Good night';
    }
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = ui.lerpDouble(0, 4, animValue)!;
        final double scale = ui.lerpDouble(1.0, 1.02, animValue)!;
        return DefaultTextStyle.merge(
          style: Theme.of(context).textTheme.bodyMedium,
          child: Transform.scale(
            scale: scale,
            child: Material(
              elevation: elevation,
              color: Colors.transparent,
              shadowColor: Colors.black12,
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
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
              _getGreeting(),
              style: theme.textTheme.headlineMedium?.copyWith(
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
              // Search navigation deferred to future milestones
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

            final pinnedTasks = displayTasks.where((t) => t.isPinned && t.status != TaskStatus.completed).toList();
            final pendingTasks = displayTasks.where((t) => !t.isPinned && t.status != TaskStatus.completed).toList();
            final completedTasks = displayTasks.where((t) => t.status == TaskStatus.completed).toList();

            return CustomScrollView(
              key: const ValueKey('home_scroll_view'),
              slivers: [
                const SliverPadding(padding: EdgeInsets.only(top: 24)),
                if (pinnedTasks.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text('Pinned', style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.primary)),
                    ),
                  ),
                  SliverReorderableList(
                    proxyDecorator: _proxyDecorator,
                    itemCount: pinnedTasks.length,
                    onReorder: (oldIndex, newIndex) {
                      if (newIndex > oldIndex) newIndex -= 1;
                      final tasksCopy = List<Task>.from(pinnedTasks);
                      final task = tasksCopy.removeAt(oldIndex);
                      tasksCopy.insert(newIndex, task);
                      final orderedIds = tasksCopy.map((t) => t.id).toList();
                      ref.read(taskNotifierProvider.notifier).reorder(orderedIds);
                    },
                    itemBuilder: (context, index) {
                      final task = pinnedTasks[index];
                      return ReorderableDelayedDragStartListener(
                        key: ValueKey(task.id),
                        index: index,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
                          child: _buildTaskCard(context, ref, task),
                        ),
                      );
                    },
                  ),
                ],
                if (pendingTasks.isNotEmpty) ...[
                  if (pinnedTasks.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text('Tasks', style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
                      ),
                    ),
                  SliverReorderableList(
                    proxyDecorator: _proxyDecorator,
                    itemCount: pendingTasks.length,
                    onReorder: (oldIndex, newIndex) {
                      if (newIndex > oldIndex) newIndex -= 1;
                      final tasksCopy = List<Task>.from(pendingTasks);
                      final task = tasksCopy.removeAt(oldIndex);
                      tasksCopy.insert(newIndex, task);
                      final orderedIds = tasksCopy.map((t) => t.id).toList();
                      ref.read(taskNotifierProvider.notifier).reorder(orderedIds);
                    },
                    itemBuilder: (context, index) {
                      final task = pendingTasks[index];
                      return ReorderableDelayedDragStartListener(
                        key: ValueKey(task.id),
                        index: index,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
                          child: _buildTaskCard(context, ref, task),
                        ),
                      );
                    },
                  ),
                ],
                if (completedTasks.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        children: [
                          Expanded(child: Divider(color: colorScheme.outlineVariant)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text('Completed', style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                          ),
                          Expanded(child: Divider(color: colorScheme.outlineVariant)),
                        ],
                      ),
                    ),
                  ),
                  SliverReorderableList(
                    proxyDecorator: _proxyDecorator,
                    itemCount: completedTasks.length,
                    onReorder: (oldIndex, newIndex) {
                      if (newIndex > oldIndex) newIndex -= 1;
                      final tasksCopy = List<Task>.from(completedTasks);
                      final task = tasksCopy.removeAt(oldIndex);
                      tasksCopy.insert(newIndex, task);
                      final orderedIds = tasksCopy.map((t) => t.id).toList();
                      ref.read(taskNotifierProvider.notifier).reorder(orderedIds);
                    },
                    itemBuilder: (context, index) {
                      final task = completedTasks[index];
                      return ReorderableDelayedDragStartListener(
                        key: ValueKey(task.id),
                        index: index,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
                          child: _buildTaskCard(context, ref, task),
                        ),
                      );
                    },
                  ),
                ],
                const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
              ],
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
          // Bottom navigation routing deferred to future milestones
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

