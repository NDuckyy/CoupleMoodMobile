import 'package:flutter/material.dart';

class ChallengeSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ChallengeSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        ...children,
      ],
    );
  }
}
