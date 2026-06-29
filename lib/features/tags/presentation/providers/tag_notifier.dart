import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/tags/domain/models/tag.dart';
import 'package:pastel_tasks/features/tags/presentation/providers/tag_providers.dart';
import 'package:pastel_tasks/core/errors/failure.dart';

/// Notifier to manage the list of tags and interact with the TagRepository.
class TagNotifier extends AsyncNotifier<List<Tag>> {
  @override
  FutureOr<List<Tag>> build() {
    final repository = ref.watch(tagRepositoryProvider);
    // Listen to changes from the repository stream
    final stream = repository.watchTags();
    final subscription = stream.listen((tags) {
      state = AsyncValue.data(tags);
    });
    
    ref.onDispose(() {
      subscription.cancel();
    });

    return repository.getTags();
  }

  /// Creates a new tag.
  Future<void> create(Tag tag) async {
    final repository = ref.read(tagRepositoryProvider);
    final result = await repository.create(tag);
    if (result is Failure) {
      state = AsyncValue.error((result as Failure).exception, StackTrace.current);
      // Wait a moment then restore data state
      final currentTags = await repository.getTags();
      state = AsyncValue.data(currentTags);
    }
  }

  /// Updates an existing tag.
  Future<void> updateTag(Tag tag) async {
    final repository = ref.read(tagRepositoryProvider);
    final result = await repository.update(tag);
    if (result is Failure) {
      state = AsyncValue.error((result as Failure).exception, StackTrace.current);
      // Wait a moment then restore data state
      final currentTags = await repository.getTags();
      state = AsyncValue.data(currentTags);
    }
  }

  /// Deletes a tag.
  Future<void> delete(String uuid) async {
    final repository = ref.read(tagRepositoryProvider);
    final result = await repository.delete(uuid);
    if (result is Failure) {
      state = AsyncValue.error((result as Failure).exception, StackTrace.current);
      final currentTags = await repository.getTags();
      state = AsyncValue.data(currentTags);
    }
  }

  /// Reorders tags in the list.
  Future<void> reorder(int oldIndex, int newIndex) async {
    if (!state.hasValue || state.value == null) return;
    
    final currentList = List<Tag>.from(state.value!);
    
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    
    final tag = currentList.removeAt(oldIndex);
    currentList.insert(newIndex, tag);
    
    // Update positions locally first for optimistic UI
    for (int i = 0; i < currentList.length; i++) {
      currentList[i] = currentList[i].copyWith(position: i.toDouble());
    }
    state = AsyncValue.data(currentList);
    
    // Persist changes
    final repository = ref.read(tagRepositoryProvider);
    for (final updatedTag in currentList) {
      await repository.update(updatedTag);
    }
  }
}

/// Provider for the TagNotifier.
final tagNotifierProvider = AsyncNotifierProvider<TagNotifier, List<Tag>>(
  () => TagNotifier(),
);
