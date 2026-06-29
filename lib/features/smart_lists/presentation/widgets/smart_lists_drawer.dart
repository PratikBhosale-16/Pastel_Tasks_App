import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/filter/presentation/providers/filter_providers.dart';
import 'package:pastel_tasks/features/smart_lists/data/repositories/smart_lists_repository.dart';
import 'package:pastel_tasks/features/smart_lists/domain/models/smart_list.dart';

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
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                itemCount: smartLists.length,
                itemBuilder: (context, index) {
                  final smartList = smartLists[index];
                  return _SmartListTile(smartList: smartList);
                },
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
