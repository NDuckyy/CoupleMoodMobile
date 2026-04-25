import 'package:flutter/material.dart';

class PostComposerHeader extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final String visibility;
  final Function(String) onVisibilityChanged;

  const PostComposerHeader({
    super.key,
    required this.name,
    this.avatarUrl,
    required this.visibility,
    required this.onVisibilityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Avatar
        CircleAvatar(
          radius: 26,
          backgroundColor: Colors.grey[200],
          backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
          child: avatarUrl == null ? const Icon(Icons.person) : null,
        ),

        const SizedBox(width: 10),

        /// Name + visibility
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Name
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 4),

              /// Visibility nhỏ gọn
              _VisibilityTag(
                value: visibility,
                onTap: () => _showBottomSheet(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.public),
              title: const Text("Công khai"),
              onTap: () {
                onVisibilityChanged("PUBLIC");
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text("Bạn bè"),
              onTap: () {
                onVisibilityChanged("FRIENDS");
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text("Chỉ mình tôi"),
              onTap: () {
                onVisibilityChanged("PRIVATE");
                Navigator.pop(ctx);
              },
            ),
          ],
        );
      },
    );
  }
}

class _VisibilityTag extends StatelessWidget {
  final String value;
  final VoidCallback onTap;

  const _VisibilityTag({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final map = {
      "PUBLIC": (Icons.public, "Công khai"),
      "FRIENDS": (Icons.group, "Bạn bè"),
      "PRIVATE": (Icons.lock, "Riêng tư"),
    };

    final current = map[value]!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(current.$1, size: 12, color: Colors.grey[700]),
            const SizedBox(width: 4),
            Text(current.$2, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 2),
            const Icon(Icons.arrow_drop_down, size: 16),
          ],
        ),
      ),
    );
  }
}
