import 'package:flutter/material.dart';

class DatePlanOverview extends StatelessWidget {
  final int total;
  final int preparing;

  const DatePlanOverview({
    super.key,
    required this.total,
    required this.preparing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF1FA), Color(0xFFF7ECFF)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _overviewItem(
              icon: Icons.calendar_month,
              value: total.toString(),
              label: 'Tổng lịch hẹn',
              color: const Color(0xFFB388EB),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _overviewItem(
              icon: Icons.schedule_outlined,
              value: preparing.toString(),
              label: 'Đang chuẩn bị',
              color: const Color(0xFFF7AEF8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _overviewItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
