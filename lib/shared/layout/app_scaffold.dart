import 'package:flutter/material.dart';

/// A custom Scaffold wrapper providing application-specific defaults
/// like pull-to-refresh, safe areas, and theming.
class AppScaffold extends StatelessWidget {
  /// Creates an app scaffold.
  const AppScaffold({
    required this.body,
    super.key,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
    this.useSafeArea = true,
    this.scrollableBody = false,
    this.keyboardSafe = true,
    this.onRefresh,
    this.backgroundColor,
    this.extendBody = false,
  });

  /// The primary content of the scaffold.
  final Widget body;

  /// Optional app bar to display at the top.
  final PreferredSizeWidget? appBar;

  /// Optional floating action button.
  final Widget? floatingActionButton;

  /// Optional bottom navigation bar.
  final Widget? bottomNavigationBar;

  /// Optional drawer.
  final Widget? drawer;

  /// Whether to wrap the body in a [SafeArea].
  final bool useSafeArea;

  /// Whether the body should be wrapped in a scroll view.
  /// Not needed if the body is already a scrollable view.
  final bool scrollableBody;

  /// Whether the body should extend behind the bottom navigation bar.
  final bool extendBody;

  /// Whether the scaffold should automatically resize to avoid the keyboard.
  final bool keyboardSafe;

  /// If provided, wraps the body in a [RefreshIndicator] executing this
  /// callback.
  final Future<void> Function()? onRefresh;

  /// Optional background color. Defaults to theme's background color.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    var content = body;

    if (scrollableBody) {
      content = SingleChildScrollView(
        physics: onRefresh != null
            ? const AlwaysScrollableScrollPhysics()
            : null,
        child: content,
      );
    }

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    if (onRefresh != null) {
      content = RefreshIndicator(
        onRefresh: onRefresh!,
        child: content,
      );
    }

    return Scaffold(
      extendBody: extendBody,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      resizeToAvoidBottomInset: keyboardSafe,
      appBar: appBar,
      body: content,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
    );
  }
}
