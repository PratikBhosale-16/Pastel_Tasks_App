import 'package:flutter_test/flutter_test.dart';
import 'package:pastel_tasks/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/widgets/services/widget_action_service.dart';
import 'package:pastel_tasks/features/widgets/services/widget_sync_service.dart';
import 'package:pastel_tasks/features/widgets/providers/widget_providers.dart';

void main() {
  testWidgets('App creates the root application shell', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        widgetActionServiceProvider.overrideWithValue(WidgetActionService()),
        widgetSyncServiceProvider.overrideWith((ref) => WidgetSyncService(null as dynamic)),
        widgetInitializationProvider.overrideWithValue(null),
      ],
      child: const App(),
    ));

    expect(find.byType(App), findsOneWidget);
  });
}
