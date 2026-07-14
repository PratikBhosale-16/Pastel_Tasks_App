import 'package:flutter_test/flutter_test.dart';
import 'package:pastel_tasks/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/widget/providers/widget_action_service.dart';
import 'package:pastel_tasks/features/widget/providers/widget_sync_service.dart';
import 'package:pastel_tasks/features/widget/providers/widget_providers.dart';
import 'package:isar/isar.dart';

void main() {
  testWidgets('App creates the root application shell', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        widgetActionServiceProvider.overrideWithValue(WidgetActionService()),
        widgetSyncServiceProvider.overrideWith((ref) => WidgetSyncService(null as Isar)),
        widgetInitializationProvider.overrideWithValue(null),
      ],
      child: const App(),
    ));

    expect(find.byType(App), findsOneWidget);
  });
}
