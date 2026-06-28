import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/core/errors/failure.dart';
import 'package:pastel_tasks/core/result/result.dart';
import 'package:pastel_tasks/features/tasks/domain/models/tag.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/repository_providers.dart';

/// Streams the list of all tags.
final tagListProvider = StreamProvider<List<Tag>>((ref) async* {
  final repository = ref.watch(tagRepositoryProvider);
  await for (final result in repository.watchAll()) {
    if (result is Success<List<Tag>>) {
      yield result.value;
    } else if (result is Failure<List<Tag>>) {
      throw result.exception;
    }
  }
});

/// Streams a specific tag by its ID.
final tagProvider = StreamProvider.family<Tag?, String>((ref, id) async* {
  final repository = ref.watch(tagRepositoryProvider);
  await for (final result in repository.watchTag(id)) {
    if (result is Success<Tag?>) {
      yield result.value;
    } else if (result is Failure<Tag?>) {
      throw result.exception;
    }
  }
});
