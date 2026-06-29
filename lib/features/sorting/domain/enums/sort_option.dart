/// Defines the available options for sorting tasks.
enum TaskSortOption {
  /// Sort manually (drag and drop order).
  manual,

  /// Sort by task creation date.
  createdDate,

  /// Sort by last updated date.
  updatedDate,

  /// Sort by task due date.
  dueDate,

  /// Sort by task reminder date.
  reminderDate,

  /// Sort by task priority.
  priority,

  /// Sort alphabetically by task title (A-Z).
  alphabetical,

  /// Sort pinned tasks first.
  pinnedFirst,

  /// Sort completed tasks last.
  completedLast,

  /// Sort by task color.
  color,

  /// Sort by primary tag name.
  tag,

  /// Sort by repeating rule.
  repeat,
}
