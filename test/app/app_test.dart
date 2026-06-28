import 'package:flutter_test/flutter_test.dart';
import 'package:pastel_tasks/app/app.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App creates the root application shell', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));

    expect(find.byType(App), findsOneWidget);
  });
}
