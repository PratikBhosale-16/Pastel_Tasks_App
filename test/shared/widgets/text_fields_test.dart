import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pastel_tasks/shared/widgets/textfields/multiline_field.dart';
import 'package:pastel_tasks/shared/widgets/textfields/password_field.dart';
import 'package:pastel_tasks/shared/widgets/textfields/primary_text_field.dart';
import 'package:pastel_tasks/shared/widgets/textfields/search_text_field.dart';

void main() {
  group('TextFields', () {
    testWidgets('PrimaryTextField accepts input', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryTextField(
              controller: controller,
              hintText: 'Enter text',
            ),
          ),
        ),
      );

      expect(find.text('Enter text'), findsOneWidget);
      await tester.enterText(find.byType(PrimaryTextField), 'Hello World');
      expect(controller.text, 'Hello World');
    });

    testWidgets('SearchTextField accepts input', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchTextField(
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.text('Search...'), findsOneWidget);
      await tester.enterText(find.byType(SearchTextField), 'query');
      expect(controller.text, 'query');
    });

    testWidgets('PasswordField toggles visibility', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PasswordField(),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);

      // Tap the visibility toggle (which is an IconButton)
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      final updatedTextField = tester.widget<TextField>(find.byType(TextField));
      expect(updatedTextField.obscureText, isFalse);
    });

    testWidgets('MultilineField accepts input', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultilineField(
              controller: controller,
              hintText: 'Notes',
            ),
          ),
        ),
      );

      expect(find.text('Notes'), findsOneWidget);
      await tester.enterText(find.byType(MultilineField), 'Line 1\nLine 2');
      expect(controller.text, 'Line 1\nLine 2');
    });
  });
}
