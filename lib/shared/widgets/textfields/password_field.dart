import 'package:flutter/material.dart';
import 'package:pastel_tasks/shared/icons/app_icons.dart';
import 'package:pastel_tasks/shared/widgets/textfields/primary_text_field.dart';

/// A specialized text field for entering passwords.
class PasswordField extends StatefulWidget {
  /// Creates a password field.
  const PasswordField({
    super.key,
    this.controller,
    this.hintText = 'Password',
    this.labelText,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.textInputAction,
  });

  /// The controller for the text field.
  final TextEditingController? controller;

  /// Text that suggests what sort of input the field accepts.
  final String hintText;

  /// Optional text that describes the input field.
  final String? labelText;

  /// Callback when the text changes.
  final ValueChanged<String>? onChanged;

  /// Callback when the user submits the text.
  final ValueChanged<String>? onSubmitted;
  
  /// Form validator callback.
  final FormFieldValidator<String>? validator;

  /// Text input action (e.g., done, next).
  final TextInputAction? textInputAction;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return PrimaryTextField(
      controller: widget.controller,
      hintText: widget.hintText,
      labelText: widget.labelText,
      obscureText: _obscureText,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      keyboardType: TextInputType.visiblePassword,
      suffixIcon: IconButton(
        icon: Icon(_obscureText ? AppIcons.visibility : AppIcons.visibilityOff),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}
