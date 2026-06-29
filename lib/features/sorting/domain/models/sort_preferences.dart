import 'package:equatable/equatable.dart';
import 'package:pastel_tasks/features/sorting/domain/enums/sort_option.dart';
import 'package:pastel_tasks/features/sorting/domain/enums/sort_order.dart';

/// Represents the active sort preferences for the application.
class SortPreferences extends Equatable {
  /// Creates a [SortPreferences] instance.
  const SortPreferences({
    this.option = TaskSortOption.manual,
    this.order = TaskSortOrder.ascending,
  });

  /// The active sort option.
  final TaskSortOption option;

  /// The active sort order (ascending or descending).
  final TaskSortOrder order;

  @override
  List<Object?> get props => [option, order];

  /// Creates a copy of this [SortPreferences] with the given fields replaced.
  SortPreferences copyWith({
    TaskSortOption? option,
    TaskSortOrder? order,
  }) {
    return SortPreferences(
      option: option ?? this.option,
      order: order ?? this.order,
    );
  }

  /// Converts this [SortPreferences] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'option': option.name,
      'order': order.name,
    };
  }

  /// Creates a [SortPreferences] from a JSON map.
  factory SortPreferences.fromJson(Map<String, dynamic> json) {
    return SortPreferences(
      option: TaskSortOption.values.firstWhere(
        (e) => e.name == json['option'],
        orElse: () => TaskSortOption.manual,
      ),
      order: TaskSortOrder.values.firstWhere(
        (e) => e.name == json['order'],
        orElse: () => TaskSortOrder.ascending,
      ),
    );
  }
}
