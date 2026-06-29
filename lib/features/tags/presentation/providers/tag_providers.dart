import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/core/providers/core_providers.dart';
import 'package:pastel_tasks/features/tags/data/repositories/tag_repository_impl.dart';
import 'package:pastel_tasks/features/tags/domain/repositories/tag_repository.dart';

/// Provider for the TagRepository implementation.
final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final isar = ref.watch(databaseProvider).instanceOrThrow;
  return TagRepositoryImpl(isar);
});
