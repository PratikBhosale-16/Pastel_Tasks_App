import 'package:flutter/material.dart';
import 'package:pastel_tasks/features/tags/domain/models/tag.dart';
import 'package:pastel_tasks/features/tags/presentation/widgets/tag_form_bottom_sheet.dart';
import 'package:pastel_tasks/app/theme/spacing.dart';

class CategorySelectionBottomSheet extends StatelessWidget {
  final List<Tag> tags;
  final String? currentTagId;

  const CategorySelectionBottomSheet({
    super.key,
    required this.tags,
    this.currentTagId,
  });

  static Future<String?> show(
    BuildContext context, {
    required List<Tag> tags,
    required String? currentTagId,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CategorySelectionBottomSheet(
        tags: tags,
        currentTagId: currentTagId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: AppSpacing.lg + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Assign Category',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ListTile(
            leading: Icon(Icons.add, color: colorScheme.primary),
            title: Text(
              '+ New Category',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            contentPadding: EdgeInsets.zero,
            onTap: () async {
              final createdTag = await TagFormBottomSheet.show(context);
              if (createdTag != null && context.mounted) {
                Navigator.of(context).pop(createdTag.id);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.clear, color: colorScheme.error),
            title: Text(
              'Clear Category',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.error,
              ),
            ),
            contentPadding: EdgeInsets.zero,
            onTap: () => Navigator.of(context).pop('NO_CATEGORY'),
          ),
          const Divider(),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: tags.map((tag) {
              final isSelected = currentTagId == tag.id;
              final tagColor = Color(int.parse(tag.color, radix: 16)).withValues(alpha: 1.0);
              
              return ChoiceChip(
                label: Text(tag.name),
                selected: isSelected,
                selectedColor: tagColor.withValues(alpha: 0.3),
                backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                side: BorderSide(
                  color: isSelected ? tagColor : Colors.transparent,
                ),
                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected ? tagColor : colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (selected) {
                  Navigator.of(context).pop(tag.id);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
