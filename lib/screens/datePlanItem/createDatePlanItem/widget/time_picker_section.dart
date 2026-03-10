import 'package:flutter/material.dart';

class TimePickerSection extends StatelessWidget {
  final ValueChanged<DateTime> onStartTimeChanged;
  final ValueChanged<DateTime> onEndTimeChanged;

  const TimePickerSection({
    super.key,
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
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TimeField(label: 'Bắt đầu', onChanged: onStartTimeChanged),
        const SizedBox(height: 12),
        TimeField(label: 'Kết thúc', onChanged: onEndTimeChanged),
      ],
    );
  }
}

class TimeField extends StatefulWidget {
  final String label;
  final ValueChanged<DateTime> onChanged;

  const TimeField({super.key, required this.label, required this.onChanged});

  @override
  State<TimeField> createState() => _TimeFieldState();
}

class _TimeFieldState extends State<TimeField> {
  TimeOfDay? _selectedTime;

  Future<void> _pickTime() async {
    final now = TimeOfDay.now();

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFFB388EB)),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() => _selectedTime = picked);

    // Gắn date = hôm nay cho DateTime
    final today = DateTime.now();

    final result = DateTime(
      today.year,
      today.month,
      today.day,
      picked.hour,
      picked.minute,
    );

    widget.onChanged(result);
  }

  String _displayText() {
    if (_selectedTime == null) return widget.label;

    return '${_selectedTime!.hour.toString().padLeft(2, '0')}:'
        '${_selectedTime!.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickTime,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFB388EB), width: 1.2),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: Color(0xFF8093F1)),
            const SizedBox(width: 12),
            Text(
              _displayText(),
              style: TextStyle(
                color: _selectedTime == null ? Colors.grey : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
