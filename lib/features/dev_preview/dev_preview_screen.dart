import 'package:flutter/material.dart';
import 'package:pastel_tasks/shared/icons/app_icons.dart';
import 'package:pastel_tasks/shared/layout/app_app_bar.dart';
import 'package:pastel_tasks/shared/layout/app_bottom_navigation.dart';
import 'package:pastel_tasks/shared/layout/app_fab.dart';
import 'package:pastel_tasks/shared/layout/app_scaffold.dart';
import 'package:pastel_tasks/shared/layout/gap.dart';
import 'package:pastel_tasks/shared/layout/page_container.dart';
import 'package:pastel_tasks/shared/layout/section_header.dart';
import 'package:pastel_tasks/shared/layout/section_spacing.dart';
import 'package:pastel_tasks/shared/widgets/buttons/icon_app_button.dart';
import 'package:pastel_tasks/shared/widgets/buttons/loading_button.dart';
import 'package:pastel_tasks/shared/widgets/buttons/outlined_app_button.dart';
import 'package:pastel_tasks/shared/widgets/buttons/primary_button.dart';
import 'package:pastel_tasks/shared/widgets/buttons/secondary_button.dart';
import 'package:pastel_tasks/shared/widgets/buttons/text_app_button.dart';
import 'package:pastel_tasks/shared/widgets/cards/base_card.dart';
import 'package:pastel_tasks/shared/widgets/cards/section_card.dart';
import 'package:pastel_tasks/shared/widgets/chips/selection_chip.dart';
import 'package:pastel_tasks/shared/widgets/textfields/multiline_field.dart';
import 'package:pastel_tasks/shared/widgets/textfields/password_field.dart';
import 'package:pastel_tasks/shared/widgets/textfields/primary_text_field.dart';
import 'package:pastel_tasks/shared/widgets/textfields/search_text_field.dart';

/// Global notifier for toggling theme in Developer Preview without persistence.
final ValueNotifier<ThemeMode> devThemeMode =
    ValueNotifier(ThemeMode.light);

/// A developer-only screen to showcase and validate all design system 
/// components.
class DevPreviewScreen extends StatefulWidget {
  /// Creates the developer preview screen.
  const DevPreviewScreen({super.key});

  @override
  State<DevPreviewScreen> createState() => _DevPreviewScreenState();
}

class _DevPreviewScreenState extends State<DevPreviewScreen> {
  int _bottomNavIndex = 0;
  bool _chipSelected1 = false;
  bool _chipSelected2 = true;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppAppBar(
        title: 'Developer Preview',
        subtitle: 'M1.4 Validation',
        isLarge: true,
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: devThemeMode,
            builder: (context, themeMode, _) {
              final isDark = themeMode == ThemeMode.dark;
              return IconAppButton(
                icon: isDark ? Icons.light_mode : Icons.dark_mode,
                tooltip: 'Toggle Theme',
                onPressed: () {
                  devThemeMode.value =
                      isDark ? ThemeMode.light : ThemeMode.dark;
                },
              );
            },
          ),
          const Gap.md(),
        ],
      ),
      scrollableBody: true,
      bottomNavigationBar: AppBottomNavigation(
        selectedIndex: _bottomNavIndex,
        onDestinationSelected: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
        destinations: const [
          AppNavigationDestination(
            icon: AppIcons.settings,
            label: 'Settings',
          ),
          AppNavigationDestination(
            icon: AppIcons.calendar,
            label: 'Calendar',
          ),
          AppNavigationDestination(
            icon: AppIcons.tag,
            label: 'Tags',
            showBadge: true,
          ),
        ],
      ),
      floatingActionButton: AppFab(
        icon: AppIcons.add,
        label: 'New Task',
        isExtended: true,
        onPressed: () {},
      ),
      body: PageContainer(
        scrollable: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionSpacing(),
            _buildThemeColorsSection(context),
            const SectionSpacing(),
            _buildTypographySection(context),
            const SectionSpacing(),
            _buildButtonsSection(),
            const SectionSpacing(),
            _buildCardsSection(),
            const SectionSpacing(),
            _buildChipsSection(),
            const SectionSpacing(),
            _buildTextFieldsSection(),
            const SectionSpacing(),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeColorsSection(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(
          title: 'Color Palette',
          subtitle: 'Design System Tokens',
        ),
        const Gap.md(),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ColorBox(
              name: 'Primary',
              color: colors.primary,
              onColor: colors.onPrimary,
            ),
            _ColorBox(
              name: 'Primary Container',
              color: colors.primaryContainer,
              onColor: colors.onPrimaryContainer,
            ),
            _ColorBox(
              name: 'Secondary',
              color: colors.secondary,
              onColor: colors.onSecondary,
            ),
            _ColorBox(
              name: 'Secondary Container',
              color: colors.secondaryContainer,
              onColor: colors.onSecondaryContainer,
            ),
            _ColorBox(
              name: 'Tertiary',
              color: colors.tertiary,
              onColor: colors.onTertiary,
            ),
            _ColorBox(
              name: 'Error',
              color: colors.error,
              onColor: colors.onError,
            ),
            _ColorBox(
              name: 'Surface',
              color: colors.surface,
              onColor: colors.onSurface,
            ),
            _ColorBox(
              name: 'Surface Container',
              color: colors.surfaceContainer,
              onColor: colors.onSurface,
            ),
            _ColorBox(
              name: 'Surface Highest',
              color: colors.surfaceContainerHighest,
              onColor: colors.onSurfaceVariant,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypographySection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Typography', subtitle: 'Outfit Font'),
        const Gap.md(),
        Text('Display Large', style: textTheme.displayLarge),
        Text('Display Medium', style: textTheme.displayMedium),
        Text('Display Small', style: textTheme.displaySmall),
        const Gap.sm(),
        Text('Headline Large', style: textTheme.headlineLarge),
        Text('Headline Medium', style: textTheme.headlineMedium),
        Text('Headline Small', style: textTheme.headlineSmall),
        const Gap.sm(),
        Text('Title Large', style: textTheme.titleLarge),
        Text('Title Medium', style: textTheme.titleMedium),
        Text('Title Small', style: textTheme.titleSmall),
        const Gap.sm(),
        Text('Body Large', style: textTheme.bodyLarge),
        Text('Body Medium', style: textTheme.bodyMedium),
        Text('Body Small', style: textTheme.bodySmall),
        const Gap.sm(),
        Text('Label Large', style: textTheme.labelLarge),
        Text('Label Medium', style: textTheme.labelMedium),
        Text('Label Small', style: textTheme.labelSmall),
      ],
    );
  }

  Widget _buildButtonsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Buttons'),
        const Gap.md(),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            PrimaryButton(label: 'Primary', onPressed: () {}),
            const PrimaryButton(label: 'Disabled'),
            SecondaryButton(label: 'Secondary', onPressed: () {}),
            const SecondaryButton(label: 'Disabled'),
            OutlinedAppButton(label: 'Outlined', onPressed: () {}),
            const OutlinedAppButton(label: 'Disabled'),
            TextAppButton(label: 'Text Button', onPressed: () {}),
            LoadingButton(
              label: 'Loading',
              isLoading: true,
              onPressed: () {},
            ),
            IconAppButton(icon: AppIcons.check, onPressed: () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildCardsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Cards'),
        const Gap.md(),
        BaseCard(
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Base Card - Main Content'),
          ),
          onTap: () {},
        ),
        const Gap.md(),
        const SectionCard(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text('Section Card - Grouped Items'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChipsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Chips'),
        const Gap.md(),
        Wrap(
          spacing: 8,
          children: [
            SelectionChip(
              label: 'Unselected',
              isSelected: _chipSelected1,
              onSelected: (val) => setState(() => _chipSelected1 = val),
            ),
            SelectionChip(
              label: 'Selected',
              isSelected: _chipSelected2,
              onSelected: (val) => setState(() => _chipSelected2 = val),
            ),
            const SelectionChip(
              label: 'Disabled',
              isSelected: false,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextFieldsSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: 'Text Fields'),
        Gap.md(),
        PrimaryTextField(
          hintText: 'Standard text field',
        ),
        Gap.md(),
        SearchTextField(
          hintText: 'Search tasks...',
        ),
        Gap.md(),
        PasswordField(
          hintText: 'Enter password',
        ),
        Gap.md(),
        MultilineField(
          hintText: 'Enter multiline notes...',
        ),
      ],
    );
  }
}

class _ColorBox extends StatelessWidget {
  const _ColorBox({
    required this.name,
    required this.color,
    required this.onColor,
  });

  final String name;
  final Color color;
  final Color onColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: color,
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: onColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
