import 'package:flutter/material.dart';

class ChallengeRules extends StatelessWidget {
  final List instructions;

  const ChallengeRules({super.key, required this.instructions});

  @override
  Widget build(BuildContext context) {
    if (instructions.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: instructions.map((e) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              const Icon(Icons.check_circle_outline, size: 18),

              const SizedBox(width: 6),

              Expanded(child: Text(e.toString())),
            ],
          ),
        );
      }).toList(),
    );
  }
}
