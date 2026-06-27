import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pastel_tasks/shared/icons/app_icons.dart';
import 'package:pastel_tasks/shared/widgets/buttons/icon_app_button.dart';
import 'package:pastel_tasks/shared/widgets/buttons/loading_button.dart';
import 'package:pastel_tasks/shared/widgets/buttons/outlined_app_button.dart';
import 'package:pastel_tasks/shared/widgets/buttons/primary_button.dart';
import 'package:pastel_tasks/shared/widgets/buttons/secondary_button.dart';
import 'package:pastel_tasks/shared/widgets/buttons/text_app_button.dart';

void main() {
  group('Buttons', () {
    testWidgets('PrimaryButton renders and responds to tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Click Me',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
      await tester.tap(find.byType(PrimaryButton));
      expect(tapped, isTrue);
    });

    testWidgets('SecondaryButton renders and responds to tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SecondaryButton(
              label: 'Click Me',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
      await tester.tap(find.byType(SecondaryButton));
      expect(tapped, isTrue);
    });

    testWidgets(
      'OutlinedAppButton renders and responds to tap',
      (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OutlinedAppButton(
              label: 'Click Me',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
      await tester.tap(find.byType(OutlinedAppButton));
      expect(tapped, isTrue);
    });

    testWidgets('TextAppButton renders and responds to tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextAppButton(
              label: 'Click Me',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
      await tester.tap(find.byType(TextAppButton));
      expect(tapped, isTrue);
    });

    testWidgets('IconAppButton renders and responds to tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconAppButton(
              icon: AppIcons.check,
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.byIcon(AppIcons.check), findsOneWidget);
      await tester.tap(find.byType(IconAppButton));
      expect(tapped, isTrue);
    });

    testWidgets('LoadingButton shows progress when loading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingButton(
              label: 'Click Me',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
