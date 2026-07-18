import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_providers.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_notifier.dart';
import 'package:pastel_tasks/features/tasks/presentation/widgets/task_card/task_card.dart';
import 'package:intl/intl.dart';

class CompletedTasksScreen extends ConsumerWidget {
  const CompletedTasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(taskListProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final tasks = ref.read(taskListProvider).valueOrNull ?? [];
              final completedIds = tasks
                  .where((t) => t.status == TaskStatus.completed)
                  .map((t) => t.id)
                  .toList();
                  
              if (completedIds.isNotEmpty) {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete all completed tasks?'),
                    content: const Text('This action cannot be undone.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: TextButton.styleFrom(foregroundColor: colorScheme.error),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                
                if (confirm == true) {
                  ref.read(taskNotifierProvider.notifier).bulkDeleteTasks(completedIds);
                  if (context.mounted) {
                    context.pop();
                  }
                }
              }
            },
          ),
        ],
      ),
      body: tasksAsync.when(
        data: (tasks) {
          final completedTasks = tasks.where((t) => t.status == TaskStatus.completed).toList();
          
          if (completedTasks.isEmpty) {
            return Center(
              child: Text(
                'No completed tasks.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }

          // Group by date (using completedAt or updatedAt)
          final groupedTasks = <String, List<Task>>{};
          final formatter = DateFormat('dd/MM/yyyy');
          
          // Sort by completion date descending
          completedTasks.sort((a, b) {
            final dateA = a.completedAt ?? a.updatedAt;
            final dateB = b.completedAt ?? b.updatedAt;
            return dateB.compareTo(dateA);
          });

          for (final task in completedTasks) {
            final date = task.completedAt ?? task.updatedAt;
            final dateStr = formatter.format(date);
            if (!groupedTasks.containsKey(dateStr)) {
              groupedTasks[dateStr] = [];
            }
            groupedTasks[dateStr]!.add(task);
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Completed Time',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...groupedTasks.entries.map((entry) {
                return _buildDateGroup(
                  context: context, 
                  dateStr: entry.key, 
                  tasks: entry.value, 
                  theme: theme, 
                  colorScheme: colorScheme,
                );
              }),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildDateGroup({
    required BuildContext context,
    required String dateStr,
    required List<Task> tasks,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline indicator
          SizedBox(
            width: 24,
            child: Stack(
              children: [
                Positioned(
                  left: 11,
                  top: 24,
                  bottom: 0,
                  child: Container(
                    width: 2,
                    color: colorScheme.primaryContainer,
                  ),
                ),
                Positioned(
                  left: 6,
                  top: 8,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.primary,
                        width: 3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 8),
                  child: Text(
                    dateStr,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...tasks.map((task) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TaskCard(task: task, showTimeline: false),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
