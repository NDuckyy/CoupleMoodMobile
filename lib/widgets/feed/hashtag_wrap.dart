import 'package:flutter/material.dart';

class HashTagWrap extends StatelessWidget {
  final List<String> tags;

  const HashTagWrap({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox();

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.pink.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            tag.startsWith("#") ? tag : "#$tag",
            style: const TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }
}
