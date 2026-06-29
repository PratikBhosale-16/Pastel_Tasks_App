import 'package:flutter/material.dart';
import 'package:pastel_tasks/features/tags/domain/models/tag.dart';

class MergeTagDialog extends StatelessWidget {
  final Tag sourceTag;
  final List<Tag> allTags;

  const MergeTagDialog({
    super.key,
    required this.sourceTag,
    required this.allTags,
  });

  static Future<Tag?> show(BuildContext context, Tag sourceTag, List<Tag> allTags) {
    return showDialog<Tag>(
      context: context,
      builder: (context) => MergeTagDialog(sourceTag: sourceTag, allTags: allTags),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final validTargets = allTags.where((t) => t.id != sourceTag.id).toList();

    return AlertDialog(
      title: const Text('Merge Tag Into...'),
      content: SizedBox(
        width: double.maxFinite,
        child: validTargets.isEmpty
            ? const Text('No other tags available to merge into.')
            : ListView.builder(
                shrinkWrap: true,
                itemCount: validTargets.length,
                itemBuilder: (context, index) {
                  final target = validTargets[index];
                  final tagColor = Color(int.parse(target.color, radix: 16));
                  final tagIcon = IconData(int.tryParse(target.icon) ?? Icons.label.codePoint, fontFamily: 'MaterialIcons');

                  return ListTile(
                    leading: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: tagColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(tagIcon, color: tagColor, size: 18),
                    ),
                    title: Text(target.name),
                    onTap: () {
                      Navigator.pop(context, target);
                    },
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
