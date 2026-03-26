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

    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 4),
      initiallyExpanded: false, // ← Mặc định đóng
      shape: const Border(), // bỏ đường viền mặc định
      title: Row(
        children: [
          const Text(
            "Chủ đề",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          if (selectedTopics.isNotEmpty)
            Text(
              "Đã chọn ${selectedTopics.length}",
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF8E24AA),
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
      subtitle: const Text(
        "Tùy chọn • Giúp bài viết dễ tìm thấy hơn",
        style: TextStyle(fontSize: 13, color: Colors.grey),
      ),
      children: [
        if (provider.loadingTopics)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator()),
          )
        else
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: provider.topics.map((topic) {
                final isSelected = selectedTopics.contains(topic.key);

                return GestureDetector(
                  onTap: () => onToggle(topic.key),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF8E24AA)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF8E24AA).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      children: [
                        Text(topic.icon, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            topic.display,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
