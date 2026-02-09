import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  final String? visitedAt;
  final String? skippedAt;

  const StatusIndicator({
    super.key,
    this.visitedAt,
    this.skippedAt,
  });

  @override
  Widget build(BuildContext context) {
    late final String text;
    late final Color color;
    late final IconData icon;

    if (visitedAt != null) {
      text = 'Đã hoàn thành';
      color = const Color(0xFF72DDF7);
      icon = Icons.check_circle;
    } else if (skippedAt != null) {
      text = 'Đã bỏ qua';
      color = Colors.grey;
      icon = Icons.cancel;
    } else {
      text = 'Sắp diễn ra';
      color = const Color(0xFFF7AEF8);
      icon = Icons.schedule;
    }

    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
