import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pastel_tasks/shared/icons/app_icons.dart';
import 'package:pastel_tasks/shared/layout/app_app_bar.dart';
import 'package:pastel_tasks/shared/layout/app_bottom_navigation.dart';
import 'package:pastel_tasks/shared/layout/app_fab.dart';
import 'package:pastel_tasks/shared/layout/app_scaffold.dart';
import 'package:pastel_tasks/shared/layout/gap.dart';
import 'package:pastel_tasks/shared/layout/page_container.dart';
import 'package:pastel_tasks/shared/layout/section_header.dart';

void main() {
  group('Layout Components', () {
    testWidgets('AppScaffold renders correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppScaffold(
            body: Text('Scaffold Body'),
            appBar: AppAppBar(title: 'App Bar'),
          ),
        ),
      );

      expect(find.text('Scaffold Body'), findsOneWidget);
      expect(find.text('App Bar'), findsOneWidget);
    });

    testWidgets('AppBottomNavigation changes selection', (tester) async {
      var selectedIndex = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: StatefulBuilder(
              builder: (context, setState) {
                return AppBottomNavigation(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() => selectedIndex = index);
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
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Settings'), findsOneWidget);
      
      // Tap second tab
      await tester.tap(find.text('Calendar'));
      await tester.pumpAndSettle();
      
      expect(selectedIndex, 1);
    });

    testWidgets('AppFab triggers onPressed', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            floatingActionButton: AppFab(
              icon: AppIcons.add,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppFab));
      expect(pressed, isTrue);
    });

    testWidgets('PageContainer applies max width and scroll', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PageContainer(
              child: Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('SectionHeader displays title and subtitle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SectionHeader(
              title: 'Main Title',
              subtitle: 'Sub Title',
            ),
          ),
        ),
      );

      expect(find.text('Main Title'), findsOneWidget);
      expect(find.text('Sub Title'), findsOneWidget);
    });
    
    testWidgets('Gap renders correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                Text('A'),
                Gap.md(),
                Text('B'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(Gap), findsOneWidget);
    });
  });
}
