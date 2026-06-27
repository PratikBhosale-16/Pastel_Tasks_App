import 'package:flutter/material.dart';
import 'package:pastel_tasks/shared/icons/app_icons.dart';
import 'package:pastel_tasks/shared/widgets/textfields/primary_text_field.dart';

/// A specialized text field for searching.
class SearchTextField extends StatefulWidget {
  /// Creates a search text field.
  const SearchTextField({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onFilterPressed,
  });

  /// The controller for the text field.
  final TextEditingController? controller;

  /// Text that suggests what sort of input the field accepts.
  final String hintText;

  /// Callback when the search text changes.
  final ValueChanged<String>? onChanged;

  /// Callback when the user submits the search.
  final ValueChanged<String>? onSubmitted;
  
  /// Optional callback for a filter action. If provided, shows a filter icon.
  final VoidCallback? onFilterPressed;

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
    _hasText = _controller.text.isNotEmpty;
  }

  @override
  void didUpdateWidget(SearchTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) {
        _controller.dispose();
      } else {
        oldWidget.controller?.removeListener(_onTextChanged);
      }
      _controller = widget.controller ?? TextEditingController();
      _controller.addListener(_onTextChanged);
      _hasText = _controller.text.isNotEmpty;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryTextField(
      controller: _controller,
      hintText: widget.hintText,
      prefixIcon: AppIcons.search,
      textInputAction: TextInputAction.search,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_hasText)
            IconButton(
              icon: const Icon(AppIcons.close),
              onPressed: () {
                _controller.clear();
                widget.onChanged?.call('');
              },
            ),
          if (widget.onFilterPressed != null)
            IconButton(
              icon: const Icon(AppIcons.filter),
              onPressed: widget.onFilterPressed,
            ),
        ],
      ),
    );
  }
}
