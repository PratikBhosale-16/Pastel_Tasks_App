import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pastel_tasks/features/filter/presentation/providers/filter_providers.dart';
import 'package:pastel_tasks/features/search/presentation/providers/search_providers.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';

void main() {
  group('Search Providers', () {
    late ProviderContainer container;
    
    final mockTasks = [
      Task(
        id: '1',
        title: 'Buy groceries',
        note: 'Milk, Eggs, Bread',
        status: TaskStatus.pending,
        priority: Priority.medium,
        tags: ['shopping', 'home'],
        createdAt: DateTime(2026, 6, 1),
        updatedAt: DateTime(2026, 6, 1),
        repeatRule: RepeatRule.weekly,
        position: 0,
        isPinned: false,
        isArchived: false,
        color: '',
        attachments: [],
      ),
      Task(
        id: '2',
        title: 'Team Meeting',
        note: 'Discuss Q3 goals',
        status: TaskStatus.pending,
        priority: Priority.high,
        tags: ['work'],
        createdAt: DateTime(2026, 6, 1),
        updatedAt: DateTime(2026, 6, 1),
        repeatRule: RepeatRule.none,
        position: 1,
        isPinned: true,
        isArchived: false,
        color: '',
        attachments: [],
      ),
      Task(
        id: '3',
        title: 'Doctor Appointment',
        note: '',
        status: TaskStatus.pending,
        priority: Priority.low,
        tags: ['health'],
        createdAt: DateTime(2026, 6, 1),
        updatedAt: DateTime(2026, 6, 1),
        repeatRule: RepeatRule.none,
        position: 2,
        isPinned: false,
        isArchived: false,
        color: '',
        attachments: [],
      ),
    ];

    setUp(() {
      container = ProviderContainer(
        overrides: [
          filteredTasksProvider.overrideWithValue(AsyncData(mockTasks)),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('searchedTasksProvider returns all filtered tasks when query is empty', () {
      final searchedTasks = container.read(searchedTasksProvider);
      
      expect(searchedTasks.value, isNotNull);
      expect(searchedTasks.value!.length, 3);
    });

    test('searchedTasksProvider matches title case-insensitively', () {
      container.read(debouncedSearchQueryProvider.notifier).state = 'GROCERIES';
      final searchedTasks = container.read(searchedTasksProvider);
      
      expect(searchedTasks.value!.length, 1);
      expect(searchedTasks.value!.first.title, 'Buy groceries');
    });

    test('searchedTasksProvider matches note', () {
      container.read(debouncedSearchQueryProvider.notifier).state = 'Q3 goals';
      final searchedTasks = container.read(searchedTasksProvider);
      
      expect(searchedTasks.value!.length, 1);
      expect(searchedTasks.value!.first.title, 'Team Meeting');
    });

    test('searchedTasksProvider matches tags', () {
      container.read(debouncedSearchQueryProvider.notifier).state = 'work';
      final searchedTasks = container.read(searchedTasksProvider);
      
      expect(searchedTasks.value!.length, 1);
      expect(searchedTasks.value!.first.title, 'Team Meeting');
    });
    
    test('searchedTasksProvider matches repeat rule', () {
      container.read(debouncedSearchQueryProvider.notifier).state = 'weekly';
      final searchedTasks = container.read(searchedTasksProvider);
      
      expect(searchedTasks.value!.length, 1);
      expect(searchedTasks.value!.first.title, 'Buy groceries');
    });
    
    test('searchedTasksProvider handles tasks with empty note gracefully', () {
      container.read(debouncedSearchQueryProvider.notifier).state = 'appointment';
      final searchedTasks = container.read(searchedTasksProvider);
      
      expect(searchedTasks.value!.length, 1);
      expect(searchedTasks.value!.first.title, 'Doctor Appointment');
    });
  });
}
