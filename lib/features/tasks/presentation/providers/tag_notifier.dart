import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/core/errors/failure.dart';
import 'package:pastel_tasks/features/tasks/domain/models/tag.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/repository_providers.dart';

/// Notifier handling tag state mutations.
class TagNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Creates a tag.
  Future<void> create(Tag tag) async {
    state = const AsyncLoading();
    final repo = ref.read(tagRepositoryProvider);
    final result = await repo.create(tag);
    if (result is Failure) {
      state = AsyncError((result as Failure).exception, StackTrace.current);
    } else {
      state = const AsyncData(null);
    }
  }

  /// Updates a tag.
  Future<void> updateTag(Tag tag) async {
    state = const AsyncLoading();
    final repo = ref.read(tagRepositoryProvider);
    final result = await repo.update(tag);
    if (result is Failure) {
      state = AsyncError((result as Failure).exception, StackTrace.current);
    } else {
      state = const AsyncData(null);
    }
  }

  /// Deletes a tag by its ID.
  Future<void> delete(String id) async {
    state = const AsyncLoading();
    final repo = ref.read(tagRepositoryProvider);
    final result = await repo.delete(id);
    if (result is Failure) {
      state = AsyncError((result as Failure).exception, StackTrace.current);
    } else {
      state = const AsyncData(null);
    }
  }

  /// Reorders tags by their IDs.
  Future<void> reorder(List<String> ids) async {
    state = const AsyncLoading();
    final repo = ref.read(tagRepositoryProvider);
    final result = await repo.reorder(ids);
    if (result is Failure) {
      state = AsyncError((result as Failure).exception, StackTrace.current);
    } else {
      state = const AsyncData(null);
    }
  }
}

/// Provides the tag notifier.
final tagNotifierProvider = AsyncNotifierProvider<TagNotifier, void>(TagNotifier.new);
