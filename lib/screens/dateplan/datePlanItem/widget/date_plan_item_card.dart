import 'package:couple_mood_mobile/screens/dateplan/datePlanItem/widget/note_section.dart';
import 'package:couple_mood_mobile/screens/dateplan/datePlanItem/widget/status_indicator.dart';
import 'package:couple_mood_mobile/screens/dateplan/datePlanItem/widget/time_range_badge.dart';
import 'package:flutter/material.dart';

class DatePlanItemCard extends StatelessWidget {
  final dynamic item; // đổi sang model nếu có

  const DatePlanItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TimeRangeBadge(startTime: item.startTime, endTime: item.endTime),
          const SizedBox(height: 12),
          NoteSection(note: item.note),
          const SizedBox(height: 12),
          StatusIndicator(visitedAt: item.visitedAt, skippedAt: item.skippedAt),
        ],
      ),
    );
  }
}
