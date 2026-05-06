import 'package:couple_mood_mobile/providers/post/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopicPickerSheet extends StatelessWidget {
  final List<String> selectedTopics;
  final Function(String) onToggle;

  const TopicPickerSheet({
    super.key,
    required this.selectedTopics,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PostProvider>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            /// Header
            Row(
              children: [
                Text(
                  "Chọn chủ đề (${selectedTopics.length})",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Xong"),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (provider.loadingTopics)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: ListView.separated(
                  itemCount: provider.topics.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final topic = provider.topics[index];
                    final isSelected = selectedTopics.contains(topic.key);

                    return _TopicTile(
                      topic: topic,
                      isSelected: isSelected,
                      onTap: () => onToggle(topic.key),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TopicTile extends StatelessWidget {
  final dynamic topic;
  final bool isSelected;
  final VoidCallback onTap;

  const _TopicTile({
    required this.topic,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF8E24AA).withOpacity(0.12)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF8E24AA) : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Text(topic.icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),

            /// text
            Expanded(
              child: Text(
                topic.display,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? const Color(0xFF8E24AA) : Colors.black87,
                ),
              ),
            ),

            /// check icon
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF8E24AA),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
