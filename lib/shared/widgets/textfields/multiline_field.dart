import 'package:flutter/material.dart';

/// A text field tailored for multiline input.
class MultilineField extends StatelessWidget {
  /// Creates a multiline field.
  const MultilineField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.minLines = 3,
    this.maxLines,
    this.onChanged,
  });

  /// The controller for the text field.
  final TextEditingController? controller;

  /// Text that suggests what sort of input the field accepts.
  final String? hintText;

  /// Optional text that describes the input field.
  final String? labelText;

  /// Minimum number of lines to display.
  final int minLines;

  /// Maximum number of lines to display.
  final int? maxLines;

  /// Callback when the text changes.
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        alignLabelWithHint: true,
      ),
    );
  }
}
