import 'package:flutter/material.dart';

class AIPromptBottomSheet extends StatefulWidget {
  const AIPromptBottomSheet({super.key});

  @override
  State<AIPromptBottomSheet> createState() => _AIPromptBottomSheetState();
}

class _AIPromptBottomSheetState extends State<AIPromptBottomSheet> {
  final TextEditingController controller = TextEditingController();

  final suggestions = [
    {"text": "Lãng mạn", "icon": Icons.favorite, "color": Colors.pink},
    {"text": "Ăn tối", "icon": Icons.restaurant, "color": Colors.orange},
    {"text": "Hoàng hôn", "icon": Icons.wb_sunny, "color": Colors.amber},
    {"text": "Đi dạo", "icon": Icons.park, "color": Colors.green},
    {"text": "Cafe", "icon": Icons.local_cafe, "color": Colors.brown},
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
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          gradient: LinearGradient(
            colors: [
              Color(0xFFFDC5F5),
              Color(0xFFF7AEF8),
              Color(0xFFB388EB),
              Color(0xFF72DDF7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Tạo kế hoạch hẹn hò 💕",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Bạn muốn buổi hẹn như thế nào?",
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "VD: lãng mạn, riêng tư, có view đẹp...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 5,
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
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          e["icon"] as IconData,
                          size: 16,
                          color: e["color"] as Color,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          e["text"] as String,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Huỷ",
                      style: TextStyle(
                        color: Color(0xFFB388EB), // tím couple mood
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, controller.text.trim());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Tạo kế hoạch",
                      style: TextStyle(color: Colors.purple),
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
