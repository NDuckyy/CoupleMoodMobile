import 'package:couple_mood_mobile/screens/datePlanItem/createDatePlanItem/widget/time_filed.dart';
import 'package:flutter/material.dart';

class TimePickerSection extends StatelessWidget {
  final DateTime? initialStart;
  final DateTime? initialEnd;

  final ValueChanged<DateTime> onStartTimeChanged;
  final ValueChanged<DateTime> onEndTimeChanged;

  const TimePickerSection({
    super.key,
    this.initialStart,
    this.initialEnd,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thời gian hẹn hò',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        TimeField(
          label: 'Bắt đầu',
          initialTime: initialStart,
          onChanged: onStartTimeChanged,
        ),

        const SizedBox(height: 12),

        TimeField(
          label: 'Kết thúc',
          initialTime: initialEnd,
          onChanged: onEndTimeChanged,
        ),
      ],
    );
  }
}