import 'package:flutter/material.dart';

/// A custom app bar that aligns with the application's design system.
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a standard or large app bar.
  const AppAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.showBackButton = true,
    this.centerTitle,
    this.isLarge = false,
  });

  /// The primary title text.
  final String? title;

  /// An optional subtitle displayed below the title.
  final String? subtitle;

  /// The widget displayed before the title. If null and [showBackButton] 
  /// is true, a default back button will be provided when navigation allows it.
  final Widget? leading;

  /// Widgets to display after the title.
  final List<Widget>? actions;

  /// Whether to show a back button if the route allows popping.
  final bool showBackButton;

  /// Whether the title should be centered.
  final bool? centerTitle;

  /// Whether this is a large variant of the app bar.
  final bool isLarge;

  @override
  Size get preferredSize => Size.fromHeight(
        isLarge ? 112.0 : kToolbarHeight + (subtitle != null ? 16.0 : 0.0),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget? titleWidget;
    if (title != null) {
      final titleStyle = isLarge
          ? theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            )
          : theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            );

      final titleText = Text(
        title!,
        style: titleStyle,
      );

      if (subtitle != null) {
        titleWidget = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: centerTitle == true
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            titleText,
            Text(
              subtitle!,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      } else {
        titleWidget = titleText;
      }
    }

    return AppBar(
      title: titleWidget,
      leading: leading,
      automaticallyImplyLeading: showBackButton,
      actions: actions,
      centerTitle: centerTitle,
      toolbarHeight: preferredSize.height,
      scrolledUnderElevation: 1,
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      titleSpacing: isLarge ? 24.0 : NavigationToolbar.kMiddleSpacing,
    );
  }
}
