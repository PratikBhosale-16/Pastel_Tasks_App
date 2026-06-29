import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/tags/presentation/providers/tag_notifier.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_providers.dart';
import 'package:pastel_tasks/features/tags/presentation/widgets/tag_form_bottom_sheet.dart';
import 'package:pastel_tasks/shared/widgets/dialogs/confirmation_dialog.dart';
import 'package:pastel_tasks/features/tags/domain/models/tag.dart';

class TagsScreen extends ConsumerWidget {
  const TagsScreen({super.key});

  Future<void> _showCreateTag(BuildContext context, WidgetRef ref) async {
    final newTag = await TagFormBottomSheet.show(context);
    if (newTag != null) {
      await ref.read(tagNotifierProvider.notifier).create(newTag);
    }
  }

  Future<void> _showEditTag(BuildContext context, WidgetRef ref, Tag tag) async {
    final updatedTag = await TagFormBottomSheet.show(context, existingTag: tag);
    if (updatedTag != null) {
      await ref.read(tagNotifierProvider.notifier).updateTag(updatedTag);
    }
  }

  Future<void> _deleteTag(BuildContext context, WidgetRef ref, Tag tag, int taskCount) async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Delete Tag?',
      message: 'This tag is used by $taskCount task(s). Deleting it will remove it from all tasks.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      isDestructive: true,
    );

    if (confirmed == true) {
      await ref.read(tagNotifierProvider.notifier).delete(tag.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tagsAsync = ref.watch(tagNotifierProvider);
    final tasksAsync = ref.watch(taskListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tags'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: tagsAsync.when(
        data: (tags) {
          if (tags.isEmpty) {
            return Center(
              child: Text(
                'No tags yet.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }

          return ReorderableListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tags.length,
            onReorder: (oldIndex, newIndex) {
              ref.read(tagNotifierProvider.notifier).reorder(oldIndex, newIndex);
            },
            itemBuilder: (context, index) {
              final tag = tags[index];
              int count = 0;
              if (tasksAsync.hasValue && tasksAsync.value != null) {
                count = tasksAsync.value!.where((t) => t.tags.contains(tag.id)).length;
              }

              final Color tagColor = Color(int.parse(tag.color, radix: 16));

              return Card(
                key: ValueKey(tag.id),
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                  ),
                ),
                elevation: 0,
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: tagColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      IconData(int.tryParse(tag.icon) ?? Icons.label.codePoint, fontFamily: 'MaterialIcons'),
                      color: tagColor,
                    ),
                  ),
                  title: Text(tag.name, style: theme.textTheme.titleMedium),
                  subtitle: Text('$count task${count == 1 ? '' : 's'}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _showEditTag(context, ref, tag),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: theme.colorScheme.error,
                        onPressed: () => _deleteTag(context, ref, tag, count),
                      ),
                      const Icon(Icons.drag_handle),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateTag(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('New Tag'),
      ),
    );
  }
}
