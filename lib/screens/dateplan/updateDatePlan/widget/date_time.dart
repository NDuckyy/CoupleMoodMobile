import 'package:flutter/material.dart';

class DatePlanDateTimePicker extends StatelessWidget {
  final DateTime? start;
  final DateTime? end;
  final ValueChanged<DateTime> onStartChanged;
  final ValueChanged<DateTime> onEndChanged;

  const DatePlanDateTimePicker({
    super.key,
    required this.start,
    required this.end,
    required this.onStartChanged,
    required this.onEndChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thời gian hẹn hò',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 8),

        _DateTimeField(
          label: 'Bắt đầu',
          value: start,
          onChanged: onStartChanged,
        ),

        const SizedBox(height: 12),

        _DateTimeField(label: 'Kết thúc', value: end, onChanged: onEndChanged),
      ],
    );
  }
}


class _DateTimeField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  const _DateTimeField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  Future<void> _pickDateTime(BuildContext context) async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: now,
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(value ?? now),
    );
    if (pickedTime == null) return;

    onChanged(
      DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      ),
    );
  }

  String _format(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');

    return '${two(dt.day)}/${two(dt.month)}/${dt.year} '
        '${two(dt.hour)}:${two(dt.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final displayText = value == null ? 'Chưa chọn' : _format(value!);

    return GestureDetector(
      onTap: () => _pickDateTime(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFB388EB), width: 1.2),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month, color: Color(0xFF8093F1)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  displayText,
                  style: TextStyle(
                    fontSize: 14,
                    color: value == null ? Colors.grey : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
