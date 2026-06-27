import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pastel_tasks/shared/widgets/cards/base_card.dart';
import 'package:pastel_tasks/shared/widgets/cards/section_card.dart';

void main() {
  group('Cards', () {
    testWidgets('BaseCard renders and responds to tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BaseCard(
              onTap: () => tapped = true,
              child: const Text('Base Card Content'),
            ),
          ),
        ),
      );

      expect(find.text('Base Card Content'), findsOneWidget);
      await tester.tap(find.byType(BaseCard));
      expect(tapped, isTrue);
    });

    testWidgets('SectionCard renders child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SectionCard(
              children: [
                Text('Section Card Content'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Section Card Content'), findsOneWidget);
    });
  });
}
