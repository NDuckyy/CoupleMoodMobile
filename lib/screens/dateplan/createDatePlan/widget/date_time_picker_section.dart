import 'package:flutter/material.dart';

class DateTimePickerSection extends StatelessWidget {
  final ValueChanged<DateTime> onStartChanged;
  final ValueChanged<DateTime> onEndChanged;

  const DateTimePickerSection({
    super.key,
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
        DateTimeField(label: 'Bắt đầu', onChanged: onStartChanged),
        const SizedBox(height: 12),
        DateTimeField(label: 'Kết thúc', onChanged: onEndChanged),
      ],
    );
  }
}

class DateTimeField extends StatefulWidget {
  final String label;
  final ValueChanged<DateTime> onChanged;

  const DateTimeField({
    super.key,
    required this.label,
    required this.onChanged,
  });

  @override
  State<DateTimeField> createState() => _DateTimeFieldState();
}

class _DateTimeFieldState extends State<DateTimeField> {
  DateTime? _selectedDateTime;

  Future<void> _pickDateTime() async {
    final DateTime now = DateTime.now();

    // Pick date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? now,
      firstDate: now,
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    // Pick time
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? now),
    );

    if (pickedTime == null) return;

    final DateTime result = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    final utcTime = result.toUtc();

    setState(() => _selectedDateTime = result);

    widget.onChanged(utcTime);
  }

  String _displayText() {
    if (_selectedDateTime == null) return widget.label;

    final dt = _selectedDateTime!;
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickDateTime,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Color(0xFFB388EB), width: 1.2),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month, color: Color(0xFF8093F1)),
            const SizedBox(width: 12),
            Text(
              _displayText(),
              style: TextStyle(
                color: _selectedDateTime == null ? Colors.grey : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
