import 'package:flutter/material.dart';

class TimeRangeBadge extends StatelessWidget {
  final String startTime;
  final String endTime;

  const TimeRangeBadge({
    super.key,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF8093F1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        '$startTime - $endTime',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
