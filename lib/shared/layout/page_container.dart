import 'package:flutter/material.dart';
import 'package:pastel_tasks/shared/layout/screen_padding.dart';

/// A container that manages responsive width, scrolling, and padding
/// for standard pages in the application.
class PageContainer extends StatelessWidget {
  /// Creates a page container.
  const PageContainer({
    required this.child,
    super.key,
    this.scrollable = true,
    this.padding = true,
    this.bottomPadding = true,
    this.maxWidth = 800.0,
  });

  /// The child widget to display inside the container.
  final Widget child;

  /// Whether the page content should be scrollable.
  final bool scrollable;

  /// Whether to apply standard [ScreenPadding].
  final bool padding;

  /// Whether to apply bottom padding when [padding] is true.
  final bool bottomPadding;

  /// The maximum width the content should expand to.
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    var content = child;

    if (padding) {
      content = ScreenPadding(
        bottom: bottomPadding,
        child: content,
      );
    }

    content = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: content,
      ),
    );

    if (scrollable) {
      content = SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: content,
      );
    }

    return content;
  }
}
