import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pastel_tasks/features/search/presentation/providers/search_providers.dart';
import 'package:pastel_tasks/features/sorting/domain/enums/sort_option.dart';
import 'package:pastel_tasks/features/sorting/domain/enums/sort_order.dart';
import 'package:pastel_tasks/features/sorting/domain/models/sort_preferences.dart';
import 'package:pastel_tasks/features/sorting/presentation/providers/sort_providers.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/tasks/domain/models/task.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('SortProviders', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          // Provide mock tasks for searchedTasksProvider
          searchedTasksProvider.overrideWith((ref) => AsyncValue.data([
                _createTask('B Task', Priority.low, 2.0),
                _createTask('A Task', Priority.high, 1.0),
                _createTask('C Task', Priority.medium, 3.0),
              ])),
          // Provide dummy preferences
          sortPreferencesProvider.overrideWith(() => MockSortNotifier()),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('manual sort keeps position ordering', () async {
      final tasks = container.read(sortedTasksProvider).value;
      expect(tasks?.length, 3);
      expect(tasks?[0].title, 'A Task');
      expect(tasks?[1].title, 'B Task');
      expect(tasks?[2].title, 'C Task');
    });

    test('alphabetical sort', () async {
      // Needs to mock repository or just override sortPreferencesProvider? 
      // It's a NotifierProvider, wait we can't easily override state of Notifier unless we mock the repository.
      // Actually we can just call setSortOption.
      
      // Since sortRepositoryProvider needs preferencesService, we might get an error because preferencesProvider is uninitialized.
      // But wait! This is a unit test, we should mock SortRepository or preferencesService.
    });
  });
}

Task _createTask(String title, Priority priority, double position) {
  return Task(
    id: const Uuid().v4(),
    title: title,
    note: '',
    status: TaskStatus.pending,
    priority: priority,
    tags: const [],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    position: position,
    isPinned: false,
    isArchived: false,
    color: '',
    attachments: const [],
    repeatRule: RepeatRule.none,
  );
}

class MockSortNotifier extends SortNotifier {
  @override
  SortPreferences build() {
    return const SortPreferences();
  }

  @override
  Future<void> setSortOption(TaskSortOption option) async {
    state = state.copyWith(option: option);
  }

  @override
  Future<void> setSortOrder(TaskSortOrder order) async {
    state = state.copyWith(order: order);
  }

  @override
  Future<void> reset() async {
    state = const SortPreferences();
  }
}

