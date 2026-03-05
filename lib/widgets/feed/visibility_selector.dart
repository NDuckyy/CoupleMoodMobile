import 'package:flutter/material.dart';

class VisibilitySelector extends StatelessWidget {
  final String value;
  final Function(String) onChanged;

  const VisibilitySelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  Widget buildOption(String key, IconData icon, String label) {
    return Builder(
      builder: (context) {
        final selected = value == key;

        return GestureDetector(
          onTap: () => onChanged(key),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? Colors.purple.shade50 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? Colors.purple : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18),
                const SizedBox(width: 6),
                Text(label),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        buildOption("PUBLIC", Icons.public, "Public"),
        buildOption("FRIENDS", Icons.group, "Friends"),
        buildOption("PRIVATE", Icons.lock, "Only me"),
      ],
    );
  }
}
