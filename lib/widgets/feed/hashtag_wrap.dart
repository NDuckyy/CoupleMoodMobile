import 'package:flutter/material.dart';

class HashTagWrap extends StatelessWidget {
  final List<String> tags;

  const HashTagWrap({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: tags.map((tag) {
        return Chip(label: Text(tag), backgroundColor: Colors.pink.shade50);
      }).toList(),
    );
  }
}
