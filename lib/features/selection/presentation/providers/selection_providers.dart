import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the set of selected task IDs for bulk operations.
class SelectionNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    return {};
  }

  /// Toggles the selection state of a task ID.
  void toggle(String id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state, id};
    }
  }

  /// Selects all the given task IDs.
  void selectAll(List<String> ids) {
    state = {...state, ...ids};
  }

  /// Clears the selection.
  void clear() {
    state = const {};
  }
}

/// Provides the SelectionNotifier and its state.
final selectionProvider = NotifierProvider<SelectionNotifier, Set<String>>(SelectionNotifier.new);

/// True if any task is selected.
final isSelectionModeProvider = Provider<bool>((ref) {
  return ref.watch(selectionProvider).isNotEmpty;
});

/// The number of currently selected tasks.
final selectionCountProvider = Provider<int>((ref) {
  return ref.watch(selectionProvider).length;
});
