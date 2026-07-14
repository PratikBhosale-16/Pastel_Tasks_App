import 'package:flutter/material.dart';
import 'package:pastel_tasks/features/tags/domain/models/tag.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';

class TagGridCard extends StatelessWidget {
  final Tag tag;
  final List<Task> tasks;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;

  const TagGridCard({
    super.key,
    required this.tag,
    required this.tasks,
    required this.onTap,
    required this.onDoubleTap,
  });

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final tagColor = Color(int.parse(tag.color, radix: 16));
    final tagIcon = IconData(int.tryParse(tag.icon) ?? Icons.label.codePoint, fontFamily: 'MaterialIcons');
    
    final totalTasks = tasks.length;
    final completedTasks = tasks.where((t) => t.status == TaskStatus.completed).length;
    final progress = totalTasks == 0 ? 0.0 : (completedTasks / totalTasks);

    // Get up to 3 most recent active tasks for preview
    final previewTasks = tasks
        .where((t) => t.status != TaskStatus.completed && !t.isArchived)
        .take(3)
        .toList();
    final remainingCount = totalTasks > 3 ? totalTasks - 3 : 0;

    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
        color: colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Icon & Task Count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: tagColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(tagIcon, color: tagColor, size: 24),
                  ),
                  if (totalTasks > 0 && completedTasks == totalTasks)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$totalTasks Task${totalTasks == 1 ? '' : 's'}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              
              // Middle: Tag Name
              Text(
                tag.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),
              
              // Task Previews + Progress Bar
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Previews (Left)
                  if (previewTasks.isNotEmpty) ...[
                    SizedBox(
                      width: 24.0 + ((previewTasks.length - 1) * 12.0) + (remainingCount > 0 ? 24 : 0),
                      height: 24,
                      child: Stack(
                        children: [
                          for (int i = 0; i < previewTasks.length; i++)
                            Positioned(
                              left: i * 12.0,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _getPriorityColor(previewTasks[i].priority),
                                  border: Border.all(color: colorScheme.surface, width: 2),
                                ),
                              ),
                            ),
                          if (remainingCount > 0)
                            Positioned(
                              left: previewTasks.length * 12.0,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorScheme.surfaceContainerHighest,
                                  border: Border.all(color: colorScheme.surface, width: 2),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '+$remainingCount',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  
                  // Progress Bar (Right)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (totalTasks > 0)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              '$completedTasks / $totalTasks',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            tween: Tween<double>(
                              begin: 0,
                              end: progress,
                            ),
                            builder: (context, value, _) {
                              return LinearProgressIndicator(
                                value: value,
                                minHeight: 6,
                                backgroundColor: tagColor.withOpacity(0.15),
                                valueColor: AlwaysStoppedAnimation<Color>(tagColor),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
