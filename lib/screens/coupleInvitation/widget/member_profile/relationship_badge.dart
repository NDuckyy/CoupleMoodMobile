import 'package:flutter/material.dart';

class RelationshipBadge extends StatelessWidget {
  final String status;

  const RelationshipBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status, style: const TextStyle(color: Colors.white)),
    );
  }
}
