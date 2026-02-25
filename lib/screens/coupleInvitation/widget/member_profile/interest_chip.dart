import 'package:flutter/material.dart';

class InterestChips extends StatelessWidget {
  final List<String> interests;

  const InterestChips({super.key, required this.interests});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: interests.map((interest) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF7AEF8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            interest,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        );
      }).toList(),
    );
  }
}