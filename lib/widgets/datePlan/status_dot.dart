import 'package:flutter/material.dart';

class StatusDot extends StatelessWidget {
  final String status;

  const StatusDot({super.key, required this.status});

  String _getStatusText(String status) {
    switch (status) {
      case 'DRAFTED':
        return 'Nháp';
      case 'PENDING':
        return 'Chờ duyệt';
      case 'SCHEDULED':
        return 'Đã duyệt';
      case 'IN_PROGRESS':
        return 'Đang diễn ra';
      case 'COMPLETED':
        return 'Đã hoàn thành';
      case 'CANCELLED':
        return 'Đã hủy';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = status == 'DRAFTED'
        ? const Color.fromARGB(255, 255, 230, 0)
        : status == 'PENDING'
        ? Colors.blue
        : status == 'SCHEDULED'
        ? const Color.fromARGB(255, 206, 87, 227)
        : status == 'IN_PROGRESS'
        ? Colors.orange
        : status == 'CANCELLED'
        ? Colors.red
        : Colors.green;
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          _getStatusText(status).toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
