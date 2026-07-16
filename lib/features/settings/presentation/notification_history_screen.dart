import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pastel_tasks/app/providers/date_time_format_provider.dart';
import 'package:pastel_tasks/features/settings/presentation/providers/notification_history_provider.dart';

class NotificationHistoryScreen extends ConsumerWidget {
  const NotificationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(notificationHistoryProvider);
    final formatter = ref.watch(dateTimeFormatterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification History'),
      ),
      body: historyAsync.when(
        data: (history) {
          if (history.isEmpty) {
            return const Center(
              child: Text('No notifications yet.'),
            );
          }

          return ListView.separated(
            itemCount: history.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final item = history[index];
              return ListTile(
                title: Text(item.taskTitle),
                subtitle: Text('${item.status.name} • ${formatter.formatDateTime(item.recordedAt)}'),
                leading: Icon(
                  item.status.name == 'missed' ? Icons.warning :
                  item.status.name == 'completed' ? Icons.check_circle :
                  item.status.name == 'snoozed' ? Icons.snooze : Icons.notifications,
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error loading history: $e')),
      ),
    );
  }
}
