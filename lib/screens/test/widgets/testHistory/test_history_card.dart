import 'package:couple_mood_mobile/models/test/test_history.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TestHistoryCard extends StatelessWidget {
  final TestHistory item;
  final VoidCallback? onTap;

  const TestHistoryCard({super.key, required this.item, this.onTap});

  String formatDate(String date) {
    final dt = DateTime.parse(date).toLocal();
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "COMPLETED":
        return Colors.green;
      case "IN_PROGRESS":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String getStatusText(String status) {
    switch (status) {
      case "COMPLETED":
        return "Đã hoàn thành";
      case "IN_PROGRESS":
        return "Đang làm";
      default:
        return "Đã lưu";
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: radius,
            border: Border.all(color: const Color(0xFFB388EB), width: 1.2),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6),
            ],
          ),
          child: Row(
            children: [
              /// ICON
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFB388EB).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.assignment, color: Color(0xFF8093F1)),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.testTypeName ?? "Bài kiểm tra tính cách",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    
                    Text(
                      item.resultCode != null
                          ? "Kết quả: ${item.resultCode}"
                          : "Kết quả: Chưa có kết quả",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 4),

                    if (item.takenAt != null)
                      Text(
                        formatDate(item.takenAt!),
                        style: const TextStyle(color: Colors.grey),
                      ),

                    const SizedBox(height: 6),

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
                            getStatusText(item.status),
                            style: TextStyle(
                              color: getStatusColor(item.status),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
