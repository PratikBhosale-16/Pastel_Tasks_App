import 'package:home_widget/home_widget.dart';
import 'package:pastel_tasks/core/logging/app_logger.dart';
import 'package:pastel_tasks/infrastructure/database/isar/database_service.dart';

@pragma('vm:entry-point')
Future<void> widgetBackgroundCallback(Uri? uri) async {
  if (uri == null) return;
  
  // Wait for ISAR to initialize if it's not already
  try {
    await DatabaseService.instance.initialize();
  } catch (e) {
    AppLogger.instance.error('Widget callback DB init failed', error: e);
  }

  AppLogger.instance.info('Widget background callback invoked: ${uri.toString()}');

  // Handle widget actions (toggle, refresh, etc.)
  if (uri.host == 'widget') {
    final path = uri.pathSegments.firstOrNull;
    if (path == 'toggle') {
       // Typically, we would parse an ID from URI parameters
       // String? taskId = uri.queryParameters['id'];
       // if (taskId != null) { ... toggle task completion ... }
       AppLogger.instance.info('Toggle requested from widget');
    } else if (path == 'refresh') {
       AppLogger.instance.info('Refresh requested from widget');
    }
  }
}
