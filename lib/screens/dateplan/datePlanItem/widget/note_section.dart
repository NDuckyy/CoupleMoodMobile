import 'package:flutter/material.dart';

class NoteSection extends StatelessWidget {
  final String note;

  const NoteSection({required this.note, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.notes,
          color: Color(0xFFB388EB),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            note,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
