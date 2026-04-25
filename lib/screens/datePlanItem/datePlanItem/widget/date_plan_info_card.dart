import 'package:couple_mood_mobile/models/dateplan/date_plan_info.dart';
import 'package:couple_mood_mobile/widgets/datePlan/status_dot.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DatePlanInfoCard extends StatelessWidget {
  final DatePlanInfo info;
  final bool isEmpty;
  final VoidCallback onAICreatePlan;

  const DatePlanInfoCard({
    super.key,
    required this.info,
    required this.isEmpty,
    required this.onAICreatePlan,
  });

  String formatDate(DateTime date) {
    return DateFormat('dd/MM • HH:mm').format(date);
  }

  String getDurationLabel(String? mode) {
    switch (mode) {
      case "SAME_DAY":
        return "Trong ngày";
      case "WITHIN_24_HOURS":
        return "Trong 24h";
      default:
        return "Không xác định";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFB388EB), Color(0xFFF7AEF8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB388EB).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    info.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (info.status != null) StatusDot(status: info.status!),
              ],
            ),

            const SizedBox(height: 12),

            _infoRow(
              icon: Icons.access_time_rounded,
              text:
                  "${formatDate(info.plannedStartAt)} → ${formatDate(info.plannedEndAt)}",
            ),

            const SizedBox(height: 8),

            _infoRow(
              icon: Icons.timelapse_rounded,
              text: getDurationLabel(info.durationMode),
            ),

            const SizedBox(height: 8),

            if (info.estimatedBudget != null)
              _infoRow(
                icon: Icons.attach_money_rounded,
                text:
                    "${NumberFormat('#,###').format(info.estimatedBudget)} VND",
              ),

            if (info.note != null && info.note!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  info.note!,
                  style: const TextStyle(color: Colors.white, height: 1.4),
                ),
              ),
            ],
            const SizedBox(height: 12),
            if (!isEmpty) ...{
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.goNamed("map");
                  },
                  icon: const Icon(Icons.map_rounded, color: Colors.white),
                  label: const Text(
                    "Xem bản đồ",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8093F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            } else ...{
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => onAICreatePlan(),
                  icon: const Icon(Icons.map_rounded, color: Colors.white),
                  label: const Text(
                    "Tạo lịch bằng AI (Beta)",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8093F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            },
          ],
        ),
      ),
    );
  }

  Widget _infoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.white),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
