import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/filter/presentation/providers/filter_providers.dart';
import 'package:pastel_tasks/features/smart_lists/data/repositories/smart_lists_repository.dart';
import 'package:pastel_tasks/features/smart_lists/domain/models/smart_list.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_providers.dart';
import 'package:pastel_tasks/features/tags/presentation/providers/tag_notifier.dart';
import 'package:pastel_tasks/features/filter/domain/models/task_filter.dart';

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
                    Icons.view_list_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Smart Lists',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final smartList = smartLists[index];
                          return _SmartListTile(smartList: smartList);
                        },
                        childCount: smartLists.length,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Divider(),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                      child: Text(
                        'Tags',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const _TagsSliverList(),
                ],
              ),
            ),
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
      leading: Icon(
        smartList.icon,
        color: smartList.color,
      ),
      title: Text(
        smartList.title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: count != null
          ? Container(
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

class _TagsSliverList extends ConsumerWidget {
  const _TagsSliverList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tagsAsync = ref.watch(tagNotifierProvider);
    final tasksAsync = ref.watch(taskListProvider);

    return tagsAsync.when(
      data: (tags) {
        if (tags.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text('No tags yet.'),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final tag = tags[index];
              int count = 0;
              if (tasksAsync.hasValue && tasksAsync.value != null) {
                count = tasksAsync.value!.where((t) => t.tags.contains(tag.id)).length;
              }

              final Color tagColor = Color(int.parse(tag.color, radix: 16));

              return ListTile(
                leading: Icon(
                  IconData(int.tryParse(tag.icon) ?? Icons.label.codePoint, fontFamily: 'MaterialIcons'),
                  color: tagColor,
                ),
                title: Text(
                  tag.name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Container(
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
            },
            childCount: tags.length,
          ),
        );
      },
      loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
      error: (err, st) => SliverToBoxAdapter(child: Text('Error: $err')),
    );
  }
}
