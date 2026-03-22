import 'package:flutter/material.dart';

class TestSectionTitle extends StatelessWidget {
  final String title;
  const TestSectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Color(0xFF8093F1),
      ),
    );
  }
}