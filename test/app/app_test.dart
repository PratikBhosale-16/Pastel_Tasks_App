import 'package:flutter_test/flutter_test.dart';
import 'package:pastel_tasks/app/app.dart';

void main() {
  testWidgets('App creates the root application shell', (tester) async {
    await tester.pumpWidget(const App());

    expect(find.byType(App), findsOneWidget);
  });
}
