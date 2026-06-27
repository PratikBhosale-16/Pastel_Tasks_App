import 'package:flutter/material.dart';
import 'package:pastel_tasks/app/theme/spacing.dart';

/// A widget that adds consistent spacing between elements in a row or column.
class Gap extends StatelessWidget {
  /// Creates a custom sized gap.
  const Gap(this.size, {super.key});

  /// Extra small gap (4.0).
  const Gap.xs({super.key}) : size = AppSpacing.xs;

  /// Small gap (8.0).
  const Gap.sm({super.key}) : size = AppSpacing.sm;

  /// Medium gap (12.0).
  const Gap.md({super.key}) : size = AppSpacing.md;

  /// Large gap (16.0).
  const Gap.lg({super.key}) : size = AppSpacing.lg;

  /// Extra large gap (20.0).
  const Gap.xl({super.key}) : size = AppSpacing.xl;

  /// Double extra large gap (24.0).
  const Gap.xxl({super.key}) : size = AppSpacing.xxl;

  /// 3x large gap (32.0).
  const Gap.x3l({super.key}) : size = AppSpacing.x3l;

  /// 4x large gap (40.0).
  const Gap.x4l({super.key}) : size = AppSpacing.x4l;

  /// The size of the gap.
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
    );
  }
}
