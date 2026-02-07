import 'package:flutter/material.dart';

class StatusDot extends StatelessWidget {
  final String status;

  const StatusDot({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status == 'DRAFTED'
        ? Colors.orange
        : Colors.green;

    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
