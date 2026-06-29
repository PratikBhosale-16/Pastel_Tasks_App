import 'package:flutter_test/flutter_test.dart';
import 'package:pastel_tasks/features/filter/domain/models/task_filter.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/priority.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/repeat_rule.dart';
import 'package:pastel_tasks/features/tasks/domain/enums/task_status.dart';
import 'package:pastel_tasks/features/filter/domain/enums/smart_date_filter.dart';

void main() {
  group('TaskFilter', () {
    test('toJson and fromJson work correctly with all fields', () {
      final filter = TaskFilter(
        tags: const ['tag1', 'tag2'],
        priorities: const [Priority.high, Priority.medium],
        statuses: const [TaskStatus.pending],
        isPinned: true,
        hasDueDate: false,
        hasReminder: true,
        repeatRules: const [RepeatRule.daily],
        colors: const ['FF0000'],
        isArchived: false,
        isCompleted: false,
        smartDateFilter: SmartDateFilter.today,
        hasTags: true,
      );

      final json = filter.toJson();
      final fromJson = TaskFilter.fromJson(json);

      expect(fromJson, equals(filter));
    });

    test('toJson and fromJson work correctly with empty fields', () {
      const filter = TaskFilter.empty;

      final json = filter.toJson();
      final fromJson = TaskFilter.fromJson(json);

      expect(fromJson, equals(filter));
    });

    test('copyWith updates fields correctly', () {
      const filter = TaskFilter.empty;
      
      final updated = filter.copyWith(
        isPinned: true,
        tags: ['tag1'],
      );

      expect(updated.isPinned, isTrue);
      expect(updated.tags, equals(['tag1']));
      expect(updated.hasDueDate, isNull);
    });

    test('copyWith clears fields correctly', () {
      final filter = TaskFilter(
        tags: const ['tag1'],
        isPinned: true,
      );

      final cleared = filter.copyWith(
        clearTags: true,
        clearPinned: true,
        clearHasTags: true,
      );

      expect(cleared.tags, isNull);
      expect(cleared.isPinned, isNull);
      expect(cleared.hasTags, isNull);
    });

    test('copyWith clears smartDateFilter correctly', () {
      final filter = TaskFilter(
        smartDateFilter: SmartDateFilter.upcoming,
      );

      final cleared = filter.copyWith(
        clearSmartDate: true,
      );

      expect(cleared.smartDateFilter, isNull);
    });

    test('hasActiveFilters returns true when filters are set', () {
      final filter1 = TaskFilter.empty.copyWith(isPinned: true);
      expect(filter1.hasActiveFilters, isTrue);

      final filter2 = TaskFilter.empty.copyWith(tags: ['tag1']);
      expect(filter2.hasActiveFilters, isTrue);

      final filter3 = TaskFilter.empty.copyWith(smartDateFilter: SmartDateFilter.today);
      expect(filter3.hasActiveFilters, isTrue);

      final filter4 = TaskFilter.empty.copyWith(hasTags: false);
      expect(filter4.hasActiveFilters, isTrue);
    });

    test('hasActiveFilters returns false when no filters are set', () {
      const filter = TaskFilter.empty;
      expect(filter.hasActiveFilters, isFalse);
    });
  });
}
