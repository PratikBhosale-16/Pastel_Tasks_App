import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/search/presentation/providers/search_providers.dart';

/// A reusable search bar for searching tasks.
class TaskSearchBar extends ConsumerStatefulWidget {
  const TaskSearchBar({super.key});

  @override
  ConsumerState<TaskSearchBar> createState() => _TaskSearchBarState();
}

class _TaskSearchBarState extends ConsumerState<TaskSearchBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(searchQueryProvider));
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Listen to provider changes to update the controller if it's cleared from outside
    ref.listen<String>(searchQueryProvider, (previous, next) {
      if (next != _controller.text) {
        _controller.text = next;
      }
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SearchBar(
        controller: _controller,
        focusNode: _focusNode,
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(colorScheme.surface),
        side: WidgetStatePropertyAll(
          BorderSide(color: colorScheme.outlineVariant, width: 1),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16.0),
        ),
        hintText: 'Search tasks...',
        hintStyle: WidgetStatePropertyAll(
          theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        textStyle: WidgetStatePropertyAll(
          theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        leading: Icon(
          Icons.search_rounded,
          color: colorScheme.onSurfaceVariant,
        ),
        trailing: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.close_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
              tooltip: 'Clear',
              onPressed: () {
                _controller.clear();
                ref.read(searchQueryProvider.notifier).clear();
                _focusNode.unfocus();
              },
            ),
        ],
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).setQuery(value);
        },
      ),
    );
  }
}
