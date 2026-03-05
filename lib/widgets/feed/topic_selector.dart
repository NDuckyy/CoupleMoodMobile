import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/post/post_provider.dart';

class TopicSelector extends StatelessWidget {
  final List<String> selectedTopics;
  final Function(String) onToggle;

  const TopicSelector({
    super.key,
    required this.selectedTopics,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PostProvider>();

    if (provider.loadingTopics) {
      return const Center(child: CircularProgressIndicator());
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: provider.topics.map((topic) {
        final selected = selectedTopics.contains(topic.key);

        return GestureDetector(
          onTap: () => onToggle(topic.key),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: selected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(topic.icon),
                const SizedBox(width: 4),
                Text(
                  topic.display,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
