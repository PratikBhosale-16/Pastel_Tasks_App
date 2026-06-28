import 'package:flutter/material.dart';

class SwipeableCard extends StatefulWidget {
  final Widget child;
  final Widget? rightActionBackground;
  final Widget Function(BuildContext context, VoidCallback close)? leftActionPaneBuilder;
  final VoidCallback? onSwipeRight;
  final double leftPaneWidth;
  final double rightSwipeThreshold;

  const SwipeableCard({
    super.key,
    required this.child,
    this.rightActionBackground,
    this.leftActionPaneBuilder,
    this.onSwipeRight,
    this.leftPaneWidth = 180.0,
    this.rightSwipeThreshold = 80.0,
  });

  @override
  State<SwipeableCard> createState() => SwipeableCardState();
}

class SwipeableCardState extends State<SwipeableCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: -1000,
      upperBound: 1000,
      value: 0.0,
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void close() {
    _controller.animateTo(0.0, curve: Curves.easeOutCubic);
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    double newValue = _controller.value + details.delta.dx;

    // Constrain dragging right
    if (widget.onSwipeRight == null && newValue > 0) {
      newValue = 0;
    }

    // Constrain dragging left
    if (widget.leftActionPaneBuilder == null && newValue < 0) {
      newValue = 0;
    }

    // Add friction when dragging past the left pane width
    if (newValue < -widget.leftPaneWidth) {
      final excess = -(newValue + widget.leftPaneWidth);
      newValue = -widget.leftPaneWidth - (excess * 0.1);
    }

    _controller.value = newValue;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_controller.value > widget.rightSwipeThreshold && widget.onSwipeRight != null) {
      widget.onSwipeRight!();
      _controller.animateTo(0.0, curve: Curves.easeOutCubic);
    } else if (_controller.value < -(widget.leftPaneWidth / 2) && widget.leftActionPaneBuilder != null) {
      _controller.animateTo(-widget.leftPaneWidth, curve: Curves.easeOutBack);
    } else {
      _controller.animateTo(0.0, curve: Curves.easeOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Right action background (shown when swiping right)
            if (widget.rightActionBackground != null && _controller.value > 0)
              Positioned.fill(
                child: widget.rightActionBackground!,
              ),
              
            // Left action pane (shown when swiping left)
            if (widget.leftActionPaneBuilder != null && _controller.value < 0)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: widget.leftPaneWidth,
                    child: widget.leftActionPaneBuilder!(context, close),
                  ),
                ),
              ),

            // The main card
            Transform.translate(
              offset: Offset(_controller.value, 0),
              child: GestureDetector(
                onHorizontalDragUpdate: _onHorizontalDragUpdate,
                onHorizontalDragEnd: _onHorizontalDragEnd,
                behavior: HitTestBehavior.opaque,
                child: widget.child,
              ),
            ),
          ],
        );
      },
    );
  }
}
