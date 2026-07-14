import 'package:flutter/material.dart';
import 'package:pastel_tasks/features/tags/domain/models/tag.dart';

class TagSelectorDropdown {
  static Future<String?> show({
    required BuildContext context,
    required Offset position,
    required List<Tag> tags,
    required String? currentTagId,
    required VoidCallback onCreateNew,
  }) async {
    final theme = Theme.of(context);
    
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect positionRect = RelativeRect.fromRect(
      Rect.fromPoints(
        position.translate(0, -60), // Pop upwards relative to the button
        position.translate(200, -60),
      ),
      Offset.zero & overlay.size,
    );

    return showMenu<String>(
      context: context,
      position: positionRect,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      color: theme.colorScheme.surface,
      items: [
        PopupMenuItem<String>(
          value: 'CREATE_NEW',
          child: Row(
            children: [
              Icon(Icons.add, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Create New',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'NO_CATEGORY',
          child: Text(
            'No Category',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: currentTagId == null 
                  ? theme.colorScheme.primary 
                  : theme.colorScheme.onSurface,
            ),
          ),
        ),
        ...tags.map((tag) {
          final isSelected = currentTagId == tag.id;
          return PopupMenuItem<String>(
            value: tag.id,
            child: Text(
              tag.name,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected 
                    ? theme.colorScheme.primary 
                    : theme.colorScheme.onSurface,
              ),
            ),
          );
        }),
      ],
    ).then((value) {
      if (value == 'CREATE_NEW') {
        onCreateNew();
        return null;
      }
      if (value == 'NO_CATEGORY') {
        return ''; // Returning empty string means "No Category"
      }
      return value;
    });
  }
}
