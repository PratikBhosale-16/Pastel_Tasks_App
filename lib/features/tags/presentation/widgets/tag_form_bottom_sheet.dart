import 'package:flutter/material.dart';
import 'package:pastel_tasks/shared/widgets/buttons/primary_button.dart';
import 'package:pastel_tasks/shared/widgets/buttons/secondary_button.dart';
import 'package:pastel_tasks/shared/widgets/textfields/primary_text_field.dart';
import 'package:pastel_tasks/features/tags/domain/models/tag.dart';
import 'package:uuid/uuid.dart';

class TagFormBottomSheet extends StatefulWidget {
  const TagFormBottomSheet({super.key, this.existingTag});

  final Tag? existingTag;

  static Future<Tag?> show(BuildContext context, {Tag? existingTag}) {
    return showModalBottomSheet<Tag>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => TagFormBottomSheet(existingTag: existingTag),
    );
  }

  @override
  State<TagFormBottomSheet> createState() => _TagFormBottomSheetState();
}

class _TagFormBottomSheetState extends State<TagFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  Color? _selectedColor;
  String? _selectedIcon;

  final List<Color> _presetColors = [
    const Color(0xFFB8A8FF), // Pastel Lavender
    const Color(0xFFA8E6CF), // Pastel Mint
    const Color(0xFFFFD3B6), // Pastel Peach
    const Color(0xFFFFE082), // Pastel Yellow
    const Color(0xFFEF9A9A), // Pastel Red
    const Color(0xFF81D4FA), // Pastel Blue
    const Color(0xFFCE93D8), // Pastel Purple
    const Color(0xFFBCAAA4), // Pastel Brown
  ];

  final List<IconData> _presetIcons = [
    Icons.label,
    Icons.work,
    Icons.home,
    Icons.person,
    Icons.favorite,
    Icons.star,
    Icons.shopping_cart,
    Icons.flight,
    Icons.school,
    Icons.fitness_center,
    Icons.restaurant,
    Icons.pets,
  ];

  @override
  void initState() {
    super.initState();
    final tag = widget.existingTag;
    if (tag != null) {
      _nameController.text = tag.name;
      _selectedColor = Color(int.parse(tag.color, radix: 16));
      _selectedIcon = tag.icon;
    } else {
      _selectedColor = _presetColors.first;
      _selectedIcon = _presetIcons.first.codePoint.toString();
    }
    _nameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final now = DateTime.now().toUtc();
      final tag = Tag(
        id: widget.existingTag?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        color: _selectedColor!.value.toRadixString(16),
        icon: _selectedIcon!,
        position: widget.existingTag?.position ?? now.millisecondsSinceEpoch.toDouble(),
        createdAt: widget.existingTag?.createdAt ?? now,
      );
      Navigator.of(context).pop(tag);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: bottomPadding + 24,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.existingTag == null ? 'New Tag' : 'Edit Tag',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      PrimaryTextField(
                        controller: _nameController,
                        labelText: 'Tag Name',
                        hintText: 'e.g., Work, Personal',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a tag name';
                          }
                          if (value.length > 30) {
                            return 'Tag name is too long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      Text('Preview', style: theme.textTheme.titleSmall),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _selectedColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_selectedIcon != null)
                                Icon(
                                  IconData(int.parse(_selectedIcon!), fontFamily: 'MaterialIcons'),
                                  size: 16,
                                  color: Colors.black87,
                                ),
                              if (_selectedIcon != null) const SizedBox(width: 6),
                              Text(
                                _nameController.text.isEmpty ? 'Tag Name' : _nameController.text,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('Color', style: theme.textTheme.titleSmall),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _presetColors.map((color) {
                          final isSelected = _selectedColor == color;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedColor = color),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(color: theme.colorScheme.primary, width: 3)
                                    : null,
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      Text('Icon', style: theme.textTheme.titleSmall),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _presetIcons.map((icon) {
                          final isSelected = _selectedIcon == icon.codePoint.toString();
                          return GestureDetector(
                            onTap: () => setState(() => _selectedIcon = icon.codePoint.toString()),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (_selectedColor?.withValues(alpha: 0.2) ?? theme.colorScheme.primaryContainer)
                                    : theme.colorScheme.surfaceContainerHighest,
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(color: _selectedColor ?? theme.colorScheme.primary, width: 2)
                                    : Border.all(color: Colors.transparent, width: 2),
                              ),
                              child: Icon(
                                icon,
                                color: isSelected
                                    ? _selectedColor
                                    : theme.colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: 'Cancel',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PrimaryButton(
                      label: widget.existingTag == null ? 'Create' : 'Save',
                      onPressed: _submit,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
