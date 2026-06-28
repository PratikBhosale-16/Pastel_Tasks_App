import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pastel_tasks/app/theme/spacing.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_notifier.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_providers.dart';
import 'package:pastel_tasks/features/tasks/presentation/widgets/add_task_bottom_sheet/add_task_bottom_sheet.dart';
import 'package:pastel_tasks/features/tasks/presentation/widgets/task_card/task_card.dart';
import 'package:pastel_tasks/shared/widgets/dialogs/confirmation_dialog.dart';
import 'package:pastel_tasks/shared/widgets/empty_state/empty_state.dart';

/// Screen for displaying archived tasks.
class ArchiveScreen extends ConsumerStatefulWidget {
  const ArchiveScreen({super.key});

  @override
  ConsumerState<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends ConsumerState<ArchiveScreen> {
  final _listKey = GlobalKey<AnimatedListState>();
  final List<Task> _tasks = [];
  bool _isInit = false;

  void _updateList(List<Task> newTasks) {
    if (!_isInit) return; // Should be initialized synchronously

    final oldIds = _tasks.map((t) => t.id).toList();
    final newIds = newTasks.map((t) => t.id).toList();

    // Removals
    for (int i = oldIds.length - 1; i >= 0; i--) {
      if (!newIds.contains(oldIds[i])) {
        final removedTask = _tasks.removeAt(i);
        _listKey.currentState?.removeItem(
          i,
          (context, animation) => _buildAnimatedItem(context, removedTask, animation),
          duration: const Duration(milliseconds: 300),
        );
      }
    }

    // Additions
    for (int i = 0; i < newTasks.length; i++) {
      if (!oldIds.contains(newTasks[i].id)) {
        _tasks.insert(i, newTasks[i]);
        _listKey.currentState?.insertItem(
          i,
          duration: const Duration(milliseconds: 300),
        );
      }
    }

    // Updates
    for (int i = 0; i < newTasks.length; i++) {
      if (i < _tasks.length && _tasks[i].id == newTasks[i].id) {
        if (_tasks[i] != newTasks[i]) {
          _tasks[i] = newTasks[i];
          // Force rebuild for state change without animation
          setState(() {});
        }
      }
    }
  }

  Future<void> _confirmAndDeleteTask(BuildContext context, Task task) async {
    final confirm = await ConfirmationDialog.show(
      context: context,
      title: 'Delete Task',
      message: 'Delete this task permanently?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      isDestructive: true,
    );

    if (confirm && context.mounted) {
      ref.read(taskNotifierProvider.notifier).delete(task.id);
      
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task deleted permanently')),
      );
    }
  }

  void _restoreTask(BuildContext context, Task task) {
    ref.read(taskNotifierProvider.notifier).restore(task.id);
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Text('Task restored'),
            const Spacer(),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.inversePrimary,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ref.read(taskNotifierProvider.notifier).archive(task.id);
              },
              child: const Text('UNDO'),
            ),
          ],
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  Future<void> _showEditSheet(BuildContext context, Task task) async {
    final formData = await AddTaskBottomSheet.show(context, existingTask: task);
    if (formData == null || !context.mounted) return;

    if (formData.isDelete) {
      _confirmAndDeleteTask(context, task);
      return;
    }
    if (formData.isRestore) {
      _restoreTask(context, task);
      return;
    }
    if (formData.isArchive) {
      // Already archived
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

    final updatedTask = task.copyWith(
      title: formData.title,
      description: formData.description,
      priority: parsePriority(formData.priority),
      tags: formData.tag != null ? [formData.tag!] : [],
      dueDate: formData.dueDate,
      repeatRule: parseRepeatRule(formData.repeatRule),
      color: formData.color?.value.toRadixString(16) ?? '',
      isPinned: formData.isPinned,
      updatedAt: DateTime.now().toUtc(),
    );
    ref.read(taskNotifierProvider.notifier).updateTask(updatedTask);
  }

  Widget _buildAnimatedItem(BuildContext context, Task task, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: TaskCard(
          task: task,
          onTap: () => _showEditSheet(context, task),
          onSwipeRight: () => _restoreTask(context, task),
          onEdit: () => _showEditSheet(context, task),
          onDelete: () => _confirmAndDeleteTask(context, task),
          onArchive: null, // Already archived
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Use stream provider if available or listen to future provider refresh
    // Wait, archivedTasksProvider is FutureProvider, but we want reactive updates.
    // Let's create an archived stream provider locally or in providers to get reactivity.
    
    // Instead of dealing with provider changes here, let's use taskListProvider and filter.
    final allTasksAsync = ref.watch(taskListProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Archive',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: allTasksAsync.when(
        data: (tasks) {
          final archivedTasks = tasks.where((t) => t.isArchived).toList();
          
          if (!_isInit) {
            _tasks.addAll(archivedTasks);
            _isInit = true;
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _updateList(archivedTasks);
            }
          });

          if (archivedTasks.isEmpty && _tasks.isEmpty) {
            return const Center(
              child: EmptyState(
                key: ValueKey('empty_archive_state'),
                title: 'No archived tasks',
                subtitle: 'Tasks you archive will appear here.',
                illustration: Icons.archive_outlined,
              ),
            );
          }

          return AnimatedList(
            key: _listKey,
            initialItemCount: _tasks.length,
            padding: const EdgeInsets.all(AppSpacing.md),
            itemBuilder: (context, index, animation) {
              // Bounds check in case of fast updates
              if (index >= _tasks.length) return const SizedBox.shrink();
              return _buildAnimatedItem(context, _tasks[index], animation);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text(
            'Failed to load archived tasks',
            style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.error),
          ),
        ),
      ),
    );
  }
}
