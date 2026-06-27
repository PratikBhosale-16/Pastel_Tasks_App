import 'package:flutter/material.dart';
import 'package:pastel_tasks/shared/layout/gap.dart';

/// A reusable header component for organizing content into distinct sections.
class SectionHeader extends StatelessWidget {
  /// Creates a section header.
  const SectionHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.trailing,
    this.actionButton,
  });

  /// The main heading text.
  final String title;

  /// Optional supporting text below the title.
  final String? subtitle;

  /// An optional widget to display on the far right (e.g., an icon or counter).
  final Widget? trailing;

  /// An optional action button (e.g., a "See All" text button) displayed 
  /// on the far right. If both [trailing] and [actionButton] are provided,
  /// they will both be displayed, typically with [trailing] first.
  final Widget? actionButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (subtitle != null) ...[
                const Gap.xs(),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null || actionButton != null) const Gap.md(),
        if (trailing != null) trailing!,
        if (trailing != null && actionButton != null) const Gap.sm(),
        if (actionButton != null) actionButton!,
      ],
    );
  }
}
