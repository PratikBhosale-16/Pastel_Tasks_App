import 'package:flutter/material.dart';
import 'package:pastel_tasks/app/theme/spacing.dart';

/// Standard spacing between major semantic sections.
class SectionSpacing extends StatelessWidget {
  /// Creates a standard section spacing gap.
  const SectionSpacing({super.key}) : size = AppSpacing.x3l;

  /// Creates a large section spacing gap.
  const SectionSpacing.large({super.key}) : size = AppSpacing.x5l;

  /// The size of the section spacing.
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
    );
  }
}
