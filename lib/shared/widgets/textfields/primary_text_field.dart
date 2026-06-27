import 'package:flutter/material.dart';

/// A standard text field for single-line text input.
class PrimaryTextField extends StatelessWidget {
  /// Creates a primary text field.
  const PrimaryTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.keyboardType,
    this.textInputAction,
  });

  /// The controller for the text field.
  final TextEditingController? controller;

  /// Text that suggests what sort of input the field accepts.
  final String? hintText;

  /// Optional text that describes the input field.
  final String? labelText;

  /// An optional icon to display before the input field.
  final IconData? prefixIcon;

  /// Optional widget to display after the input field.
  final Widget? suffixIcon;

  /// Whether the input should be obscured (e.g. for passwords).
  final bool obscureText;

  /// Callback when the text changes.
  final ValueChanged<String>? onChanged;

  /// Callback when the user submits the text.
  final ValueChanged<String>? onSubmitted;
  
  /// Form validator callback.
  final FormFieldValidator<String>? validator;
  
  /// Keyboard type for the input.
  final TextInputType? keyboardType;
  
  /// Text input action (e.g., done, next).
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
