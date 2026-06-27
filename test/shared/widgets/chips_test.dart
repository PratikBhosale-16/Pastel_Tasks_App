import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pastel_tasks/shared/widgets/chips/selection_chip.dart';

void main() {
  group('Chips', () {
    testWidgets('SelectionChip renders and toggles', (tester) async {
      var selected = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return SelectionChip(
                  label: 'Tag',
                  isSelected: selected,
                  onSelected: (val) {
                    setState(() => selected = val);
                  },
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Tag'), findsOneWidget);
      
      // Tap to select
      await tester.tap(find.byType(SelectionChip));
      await tester.pumpAndSettle();
      expect(selected, isTrue);

      // Tap to deselect
      await tester.tap(find.byType(SelectionChip));
      await tester.pumpAndSettle();
      expect(selected, isFalse);
    });
  });
}
