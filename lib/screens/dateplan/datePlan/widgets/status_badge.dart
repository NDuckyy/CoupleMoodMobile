import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isDraft = status == 'DRAFTED';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isDraft ? Colors.orange : Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isDraft ? 'Chuẩn bị' : 'Hoàn thành',
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
