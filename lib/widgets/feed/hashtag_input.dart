import 'package:flutter/material.dart';

class HashtagInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(List<String>)? onChanged;

  const HashtagInput({super.key, required this.controller, this.onChanged});

  @override
  State<HashtagInput> createState() => _HashtagInputState();
}

class _HashtagInputState extends State<HashtagInput> {
  List<String> tags = [];

  @override
  void initState() {
    super.initState();

    if (widget.controller.text.isNotEmpty) {
      parseTags(widget.controller.text);
    }
  }

  void parseTags(String text) {
    final raw = text
        .replaceAll(",", " ")
        .split(" ")
        .where((e) => e.trim().isNotEmpty)
        .toList();

    final cleaned = raw
        .map((e) {
          final t = e.replaceAll("#", "").trim().toLowerCase();
          return t.isEmpty ? null : "#$t";
        })
        .whereType<String>()
        .toSet()
        .toList();

    setState(() {
      tags = cleaned;
    });

    widget.onChanged?.call(cleaned);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          onChanged: parseTags,
          decoration: const InputDecoration(
            labelText: "Hashtags",
            hintText: "#love #dating",
            prefixIcon: Icon(Icons.tag),
          ),
        ),
        const SizedBox(height: 8),
        if (tags.isNotEmpty)
          Wrap(
            spacing: 6,
            children: tags.map((tag) {
              return Chip(
                label: Text(tag),
                backgroundColor: Colors.pink.shade50,
                labelStyle: const TextStyle(color: Colors.pink),
              );
            }).toList(),
          ),
      ],
    );
  }
}
