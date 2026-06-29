import 'package:flutter/material.dart';

enum TagContextAction {
  edit,
  duplicate,
  merge,
  delete,
}

class TagContextMenuBottomSheet extends StatelessWidget {
  final String tagName;

  const TagContextMenuBottomSheet({
    super.key,
    required this.tagName,
  });

  static Future<TagContextAction?> show(BuildContext context, String tagName) {
    return showModalBottomSheet<TagContextAction>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => TagContextMenuBottomSheet(tagName: tagName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            tagName,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.edit_outlined, color: colorScheme.onSurface),
            title: const Text('Edit'),
            onTap: () => Navigator.pop(context, TagContextAction.edit),
          ),
          ListTile(
            leading: Icon(Icons.copy_outlined, color: colorScheme.onSurface),
            title: const Text('Duplicate'),
            onTap: () => Navigator.pop(context, TagContextAction.duplicate),
          ),
          ListTile(
            leading: Icon(Icons.call_merge_outlined, color: colorScheme.onSurface),
            title: const Text('Merge Into...'),
            onTap: () => Navigator.pop(context, TagContextAction.merge),
          ),
          ListTile(
            leading: Icon(Icons.delete_outline, color: colorScheme.error),
            title: Text('Delete', style: TextStyle(color: colorScheme.error)),
            onTap: () => Navigator.pop(context, TagContextAction.delete),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
