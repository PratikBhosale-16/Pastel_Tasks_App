import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pastel_tasks/app/router/route_names.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/filter/presentation/providers/filter_providers.dart';
import 'package:pastel_tasks/features/smart_lists/data/repositories/smart_lists_repository.dart';
import 'package:pastel_tasks/features/smart_lists/domain/models/smart_list.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_providers.dart';
import 'package:pastel_tasks/features/tags/presentation/providers/tag_notifier.dart';
import 'package:pastel_tasks/features/filter/domain/models/task_filter.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';

class SmartListGroup {
  final String title;
  final IconData icon;
  final List<String> listIds;

  const SmartListGroup(this.title, this.icon, this.listIds);
}

const _smartListGroups = [
  SmartListGroup('General', Icons.inbox_outlined, ['inbox', 'today', 'tomorrow', 'upcoming']),
  SmartListGroup('Time & Schedule', Icons.alarm, ['overdue', 'this_week', 'this_month', 'no_due_date']),
  SmartListGroup('Task Status', Icons.task_alt, ['active', 'completed_today', 'completed', 'archived']),
  SmartListGroup('Organization', Icons.star_border, ['pinned', 'high_priority', 'medium_priority', 'low_priority', 'repeating', 'untagged', 'no_reminder']),
];

class SmartListsDrawer extends ConsumerWidget {
  const SmartListsDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final smartLists = ref.watch(smartListsProvider);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Row(
                children: [
                  Icon(
                    Icons.task_alt,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Pastel Tasks',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                children: [
                  ..._smartListGroups.map((group) {
                    final groupLists = group.listIds
                        .map((id) => smartLists.cast<SmartList?>().firstWhere((sl) => sl?.id == id, orElse: () => null))
                        .whereType<SmartList>()
                        .toList();

                    return Theme(
                      data: theme.copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        initiallyExpanded: false,
                        leading: Icon(group.icon),
                        title: Text(
                          group.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        children: groupLists.map((smartList) {
                          return _SmartListTile(
                            smartList: smartList,
                          );
                        }).toList(),
                      ),
                    );
                  }),
                  const _CategoriesExpansionTile(),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(Icons.settings_outlined, color: theme.colorScheme.onSurfaceVariant),
              title: Text(
                'Settings',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context); // Close drawer
                context.pushNamed(RouteNames.settings);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _SmartListTile extends ConsumerWidget {
  const _SmartListTile({required this.smartList});

  final SmartList smartList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tasksAsync = ref.watch(taskListProvider);

    int? count;
    if (tasksAsync.hasValue && tasksAsync.value != null) {
      count = tasksAsync.value!.where((t) => smartList.filter.matches(t)).length;
    }

    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Icon(
          smartList.icon,
          color: smartList.color,
          size: 20,
        ),
      ),
      minLeadingWidth: 0,
      title: Text(
        smartList.title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: count != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          : const SizedBox.shrink(),
      onTap: () {
        // Apply the smart list's filter
        ref.read(filterProvider.notifier).updateFilter(smartList.filter);
        // If sortPrefs is provided, apply them
        // if (smartList.sortPrefs != null) {
        //   ref.read(sortPreferencesProvider.notifier).updateSortPreferences(smartList.sortPrefs!);
        // }
        // Close the drawer
        Navigator.pop(context);
      },
    );
  }
}

class _CategoriesExpansionTile extends ConsumerWidget {
  const _CategoriesExpansionTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tagsAsync = ref.watch(tagNotifierProvider);
    final tasksAsync = ref.watch(taskListProvider);

    return tagsAsync.when(
      data: (tags) {
        if (tags.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('No categories yet.'),
          );
        }

        return Theme(
          data: theme.copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
          initiallyExpanded: false,
          title: Text(
            'Categories',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: const Icon(Icons.label_outline),
          children: tags.map((tag) {
              int count = 0;
              bool allCompleted = false;
              if (tasksAsync.hasValue && tasksAsync.value != null) {
                final tagTasks = tasksAsync.value!.where((t) => t.tags.contains(tag.id) && !t.isArchived).toList();
                count = tagTasks.length;
                if (count > 0 && tagTasks.every((t) => t.status == TaskStatus.completed)) {
                  allCompleted = true;
                }
              }

              final Color tagColor = Color(int.parse(tag.color, radix: 16));
              return ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Icon(
                    IconData(int.tryParse(tag.icon) ?? Icons.label.codePoint, fontFamily: 'MaterialIcons'),
                    color: tagColor,
                    size: 20,
                  ),
                ),
                minLeadingWidth: 0,
                title: Text(
                  tag.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: allCompleted
                    ? Container(
                        padding: const EdgeInsets.all(4),
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
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$count',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                onTap: () {
                  // Apply tag filter
                  ref.read(filterProvider.notifier).updateFilter(TaskFilter(tags: [tag.id]));
                  Navigator.pop(context);
                },
              );
          }).toList(),
        ),
      );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Text('Error: $err'),
    );
  }
}
