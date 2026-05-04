import 'package:flutter/material.dart';

class AIPromptBottomSheet extends StatefulWidget {
  const AIPromptBottomSheet({super.key});

  @override
  State<AIPromptBottomSheet> createState() => _AIPromptBottomSheetState();
}

class _AIPromptBottomSheetState extends State<AIPromptBottomSheet> {
  final TextEditingController controller = TextEditingController();

final suggestions = [
  {"text": "Hẹn hò lãng mạn buổi tối", "icon": Icons.favorite_border},
  {"text": "Ăn tối view đẹp", "icon": Icons.restaurant_menu},
  {"text": "Đi dạo công viên", "icon": Icons.park_outlined},
  {"text": "Cafe yên tĩnh nói chuyện", "icon": Icons.local_cafe_outlined},
];

  void addSuggestion(String text) {
    if (controller.text.isEmpty) {
      controller.text = text;
    } else {
      controller.text += ", $text";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// handle
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 16),

            /// title
            const Text(
              "Tạo kế hoạch hẹn hò",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              "Bạn muốn buổi hẹn như thế nào?",
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),

            const SizedBox(height: 14),

            /// input
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "VD: lãng mạn, riêng tư, view đẹp...",
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(14),
              ),
            ),

            const SizedBox(height: 12),

            /// suggestions
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: suggestions.map((e) {
                return GestureDetector(
                  onTap: () => addSuggestion(e["text"] as String),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF), // tím rất nhạt
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          e["icon"] as IconData,
                          size: 16,
                          color: const Color(0xFFB388EB),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          e["text"] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 18),

            /// buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text("Huỷ"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, controller.text.trim());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB388EB),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Tạo kế hoạch",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<String?> showAIPromptBottomSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const AIPromptBottomSheet(),
  );
}
