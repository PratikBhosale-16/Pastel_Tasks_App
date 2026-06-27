import 'package:flutter/material.dart';
import 'package:pastel_tasks/app/theme/spacing.dart';
import 'package:pastel_tasks/shared/widgets/cards/base_card.dart';

/// A card designed specifically for grouping related form fields or
/// settings sections.
class SectionCard extends StatelessWidget {
  /// Creates a section card.
  const SectionCard({
    required this.children,
    super.key,
    this.title,
  });

  /// The children widgets to display inside the section.
  final List<Widget> children;
  
  /// The title of the section.
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BaseCard(
      color: theme.colorScheme.surfaceContainerLow,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          ...children,
        ],
      ),
    );
  }
}
