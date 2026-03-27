import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TestHistoryCard extends StatelessWidget {
  final dynamic item;

  const TestHistoryCard({super.key, required this.item});

  String formatDate(String date) {
    final dt = DateTime.parse(date).toLocal();
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "completed":
        return Colors.green;
      case "pending":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB388EB), width: 1.2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          /// LEFT ICON
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFB388EB).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.assignment, color: Color(0xFF8093F1)),
          ),

          const SizedBox(width: 12),

          /// CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// RESULT
                Text(
                  "Kết quả: ${item.resultCode}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 4),

                /// DATE
                Text(
                  formatDate(item.takenAt),
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 6),

                /// STATUS
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: getStatusColor(item.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.status,
                        style: TextStyle(
                          color: getStatusColor(item.status),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Test #${item.testTypeId}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
