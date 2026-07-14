import 'package:flutter_test/flutter_test.dart';
import 'package:pastel_tasks/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/widgets/data/widget_sync_service.dart';

void main() {
  testWidgets('App creates the root application shell', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        widgetSyncServiceProvider.overrideWith(WidgetSyncService.new),
      ],
      child: const App(),
    ));

    expect(find.byType(App), findsOneWidget);
  });
}
