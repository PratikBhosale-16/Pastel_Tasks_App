import 'package:flutter/material.dart';
import 'package:pastel_tasks/app/theme/colors.dart';
import 'package:pastel_tasks/app/theme/spacing.dart';

/// A developer-only page for visually verifying the design tokens
/// and core themed Material components.
class ThemePreviewPage extends StatelessWidget {
  /// Creates a new [ThemePreviewPage].
  const ThemePreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Preview'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text('Typography', style: textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          Text('Display Large', style: textTheme.displayLarge),
          Text('Headline Large', style: textTheme.headlineLarge),
          Text('Title Large', style: textTheme.titleLarge),
          Text('Body Large', style: textTheme.bodyLarge),
          Text('Label Large', style: textTheme.labelLarge),
          
          const Divider(height: AppSpacing.x4l),
          
          Text('Colors', style: textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          const Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _ColorBox(color: AppColors.primary, name: 'Primary'),
              _ColorBox(color: AppColors.secondary, name: 'Secondary'),
              _ColorBox(color: AppColors.tertiary, name: 'Tertiary'),
              _ColorBox(color: AppColors.success, name: 'Success'),
              _ColorBox(color: AppColors.warning, name: 'Warning'),
              _ColorBox(color: AppColors.error, name: 'Error'),
              _ColorBox(color: AppColors.info, name: 'Info'),
            ],
          ),
          
          const Divider(height: AppSpacing.x4l),
          
          Text('Components', style: textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          
          const TextField(
            decoration: InputDecoration(
              labelText: 'Input Field',
              hintText: 'Placeholder text',
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          const Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text('This is a Card component'),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {},
                  child: const Text('Filled Button'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Outlined'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          
          Row(
            children: [
              const Chip(label: Text('Chip Label')),
              const SizedBox(width: AppSpacing.md),
              Checkbox(value: true, onChanged: (_) {}),
              const SizedBox(width: AppSpacing.md),
              Switch(value: true, onChanged: (_) {}),
            ],
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class _ColorBox extends StatelessWidget {
  const _ColorBox({required this.color, required this.name});

  final Color color;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          name,
          style: const TextStyle(fontSize: 10, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
