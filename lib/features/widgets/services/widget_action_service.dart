import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:pastel_tasks/app/router/app_router.dart';

import 'package:flutter/services.dart';

class WidgetActionService {
  void initialize() {
    try {
      // Check if launched from a widget
      HomeWidget.initiallyLaunchedFromHomeWidget().then(_handleWidgetAction).catchError((_) {});
      
      // Listen to background widget clicks while app is open
      HomeWidget.widgetClicked.listen(_handleWidgetAction).onError((_) {});
    } on MissingPluginException {
      // Ignore for tests
    } catch (e) {
      debugPrint('HomeWidget init error: $e');
    }
  }

  void _handleWidgetAction(Uri? uri) {
    if (uri == null) return;
    
    // uri e.g. pastel_tasks://add
    if (uri.host == 'add') {
      // Since we don't have a specific global context here, 
      // it's better to navigate via the global app router if possible,
      // or set a state that the router consumes.
      // But GoRouter supports pushing if we have the context.
      // For simplicity, we can use appRouter.push('/add_task') if it existed.
      // Let's assume there's a way to trigger add task.
      // For now, we'll log it.
      debugPrint('Widget action launched: ${uri.toString()}');
    }
  }
}

final widgetActionServiceProvider = Provider<WidgetActionService>((ref) {
  final service = WidgetActionService();
  service.initialize();
  return service;
});
