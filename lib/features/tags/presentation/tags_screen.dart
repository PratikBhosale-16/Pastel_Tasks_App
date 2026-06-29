import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pastel_tasks/app/router/route_names.dart';
import 'dart:ui';
import 'package:pastel_tasks/features/filter/domain/models/task_filter.dart';
import 'package:pastel_tasks/features/filter/presentation/providers/filter_providers.dart';
import 'package:pastel_tasks/features/tags/domain/models/tag.dart';
import 'package:pastel_tasks/features/tags/presentation/providers/tag_notifier.dart';
import 'package:pastel_tasks/features/tags/presentation/widgets/merge_tag_dialog.dart';
import 'package:pastel_tasks/features/tags/presentation/widgets/tag_context_menu_bottom_sheet.dart';
import 'package:pastel_tasks/features/tags/presentation/widgets/tag_form_bottom_sheet.dart';
import 'package:pastel_tasks/features/tags/presentation/widgets/tag_grid_card.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_notifier.dart';
import 'package:pastel_tasks/features/tasks/presentation/providers/task_providers.dart';
import 'package:pastel_tasks/shared/widgets/dialogs/confirmation_dialog.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:uuid/uuid.dart';

class TagsScreen extends ConsumerStatefulWidget {
  const TagsScreen({super.key});

  @override
  ConsumerState<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends ConsumerState<TagsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    // Start stagger animation automatically on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _staggerController.forward();
    });
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  Future<void> _showCreateTag() async {
    final newTag = await TagFormBottomSheet.show(context);
    if (newTag != null) {
      await ref.read(tagNotifierProvider.notifier).create(newTag);
    }
  }

  Future<void> _showEditTag(Tag tag) async {
    final updatedTag = await TagFormBottomSheet.show(context, existingTag: tag);
    if (updatedTag != null) {
      await ref.read(tagNotifierProvider.notifier).updateTag(updatedTag);
    }
  }

  Future<void> _duplicateTag(Tag tag) async {
    final newTag = Tag(
      id: const Uuid().v4(),
      name: '${tag.name} (Copy)',
      color: tag.color,
      icon: tag.icon,
      position: tag.position + 1,
      createdAt: DateTime.now(),
    );
    await ref.read(tagNotifierProvider.notifier).create(newTag);
  }

  Future<void> _mergeTag(Tag sourceTag, List<Tag> allTags) async {
    final destTag = await MergeTagDialog.show(context, sourceTag, allTags);
    if (destTag != null) {
      await ref.read(taskNotifierProvider.notifier).mergeTags(sourceTag.id, destTag.id);
      await ref.read(tagNotifierProvider.notifier).delete(sourceTag.id);
    }
  }

  Future<void> _deleteTag(Tag tag, int taskCount) async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Delete Tag?',
      message: 'This tag is used by $taskCount task(s). Deleting it will remove it from all tasks.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      isDestructive: true,
    );

    if (confirmed == true) {
      await ref.read(tagNotifierProvider.notifier).delete(tag.id);
    }
  }

  void _onTagDoubleTapped(Tag tag, List<Tag> allTags, int taskCount) async {
    final action = await TagContextMenuBottomSheet.show(context, tag.name);
    if (action != null) {
      switch (action) {
        case TagContextAction.edit:
          await _showEditTag(tag);
          break;
        case TagContextAction.duplicate:
          await _duplicateTag(tag);
          break;
        case TagContextAction.merge:
          await _mergeTag(tag, allTags);
          break;
        case TagContextAction.delete:
          await _deleteTag(tag, taskCount);
          break;
      }
    }
  }

  void _onTagTapped(Tag tag) {
    // Apply tag filter and go to home screen
    ref.read(filterProvider.notifier).updateFilter(TaskFilter(tags: [tag.id]));
    context.go(RouteNames.homePath);
  }

  Widget _buildNewTagCard() {
    final theme = Theme.of(context);
    return GestureDetector(
      key: const ValueKey('new_tag_btn'),
      onTap: _showCreateTag,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withOpacity(0.5),
            width: 2,
            style: BorderStyle.none,
          ),
        ),
        child: CustomPaint(
          painter: _DashedBorderPainter(color: theme.colorScheme.outlineVariant),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 12),
              Text(
                'New Tag',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tagsAsync = ref.watch(tagNotifierProvider);
    final tasksAsync = ref.watch(taskListProvider);

    // Responsive columns
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    if (screenWidth > 600) crossAxisCount = 3;
    if (screenWidth > 900) crossAxisCount = 4;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Tags',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Organize your focus areas.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        toolbarHeight: 90,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: tagsAsync.when(
        data: (tags) {
          final allTasks = tasksAsync.value ?? [];
          
          return ReorderableGridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            onReorder: (oldIndex, newIndex) {
              // 'New Tag' card is at the end, prevent moving it or moving over it.
              if (oldIndex == tags.length || newIndex == tags.length) return;
              HapticFeedback.lightImpact();
              ref.read(tagNotifierProvider.notifier).reorder(oldIndex, newIndex);
            },
            onDragStart: (index) {
              HapticFeedback.mediumImpact();
            },
            itemCount: tags.length + 1, // +1 for "New Tag" tile
            itemBuilder: (context, index) {
              if (index == tags.length) {
                return _buildNewTagCard();
              }
              
              final tag = tags[index];
              final tagTasks = allTasks.where((t) => t.tags.contains(tag.id)).toList();

              // Staggered animation values
              final double start = (index * 0.1).clamp(0.0, 1.0);
              final double end = (start + 0.5).clamp(0.0, 1.0);
              
              final animation = CurvedAnimation(
                parent: _staggerController,
                curve: Interval(start, end, curve: Curves.easeOutCubic),
              );

              return AnimatedBuilder(
                key: ValueKey(tag.id),
                animation: animation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 30 * (1 - animation.value)),
                    child: Transform.scale(
                      scale: 0.95 + (0.05 * animation.value),
                      child: Opacity(
                        opacity: animation.value,
                        child: child,
                      ),
                    ),
                  );
                },
                child: TagGridCard(
                  tag: tag,
                  tasks: tagTasks,
                  onTap: () => _onTagTapped(tag),
                  onDoubleTap: () => _onTagDoubleTapped(tag, tags, tagTasks.length),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(20),
      ));

    // A simple dashed path logic (approximated for rectangles)
    final dashPath = Path();
    for (PathMetric measurePath in path.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < measurePath.length) {
        final double length = draw ? 8.0 : 6.0;
        if (draw) {
          dashPath.addPath(
            measurePath.extractPath(distance, distance + length),
            Offset.zero,
          );
        }
        distance += length;
        draw = !draw;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
