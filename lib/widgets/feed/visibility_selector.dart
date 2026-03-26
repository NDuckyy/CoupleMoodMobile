import 'package:flutter/material.dart';

class VisibilitySelector extends StatelessWidget {
  final String value;
  final Function(String) onChanged;

  const VisibilitySelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.public),
              title: const Text("Công khai"),
              subtitle: const Text("Ai cũng có thể xem"),
              trailing: value == "PUBLIC"
                  ? const Icon(Icons.check, color: Color(0xFF8E24AA))
                  : null,
              onTap: () {
                onChanged("PUBLIC");
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text("Bạn bè"),
              subtitle: const Text("Chỉ bạn bè xem được"),
              trailing: value == "FRIENDS"
                  ? const Icon(Icons.check, color: Color(0xFF8E24AA))
                  : null,
              onTap: () {
                onChanged("FRIENDS");
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text("Chỉ mình tôi"),
              subtitle: const Text("Chỉ bạn mới thấy"),
              trailing: value == "PRIVATE"
                  ? const Icon(Icons.check, color: Color(0xFF8E24AA))
                  : null,
              onTap: () {
                onChanged("PRIVATE");
                Navigator.pop(ctx);
              },
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, (IconData, String)> options = {
      "PUBLIC": (Icons.public, "Công khai"),
      "FRIENDS": (Icons.group, "Bạn bè"),
      "PRIVATE": (Icons.lock, "Chỉ mình tôi"),
    };

    final current = options[value]!;

    return GestureDetector(
      onTap: () => _showBottomSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(current.$1, color: Colors.grey[700], size: 22),
            const SizedBox(width: 12),
            Text(
              current.$2,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
