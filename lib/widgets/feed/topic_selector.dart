import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/post/post_provider.dart';
import 'topic_picker_sheet.dart';
import 'package:flutter/services.dart';

class TopicSelector extends StatelessWidget {
  final List<String> selectedTopics;
  final Function(String) onToggle;

  const TopicSelector({
    super.key,
    required this.selectedTopics,
    required this.onToggle,
  });

  void _openPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return TopicPickerSheet(
              selectedTopics: selectedTopics,
              onToggle: (key) {
                onToggle(key);
                setModalState(() {});
              },
            );
          },
        );
      },
    );
  }

  String getDisplayText(PostProvider provider, String key) {
    final topic = provider.topics.firstWhere(
      (e) => e.key == key,
      orElse: () => provider.topics.first,
    );
    return topic.display;
  }

  String getIcon(PostProvider provider, String key) {
    final topic = provider.topics.firstWhere(
      (e) => e.key == key,
      orElse: () => provider.topics.first,
    );
    return topic.icon;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PostProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title
        Row(
          children: const [
            Text("Chủ đề", style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(width: 6),
            Text(
              "(tùy chọn)",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),

        const SizedBox(height: 8),

        /// Chips
        Column(
          children: [
            ...selectedTopics.map((t) {
              final isSelected = selectedTopics.contains(t);

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Material(
                  key: ValueKey(t),
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      onToggle(t);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF8E24AA).withOpacity(0.1)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF8E24AA)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            getIcon(provider, t),
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              getDisplayText(provider, t),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? const Color(0xFF8E24AA)
                                    : Colors.black87,
                              ),
                            ),
                          ),

                          const Icon(Icons.close, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),

            /// nút thêm
            GestureDetector(
              onTap: () => _openPicker(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: const [
                    Icon(Icons.add, size: 18, color: Colors.grey),
                    SizedBox(width: 6),
                    Text(
                      "Chỉnh sửa chủ đề",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        /// Hint nhỏ
        if (selectedTopics.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(
              "Giúp bài viết dễ được khám phá hơn",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
      ],
    );
  }
}
