import 'package:flutter/material.dart';

class TimeField extends StatefulWidget {
  final String label;
  final DateTime? initialTime;
  final ValueChanged<DateTime> onChanged;

  const TimeField({
    super.key,
    required this.label,
    required this.onChanged,
    this.initialTime,
  });

  @override
  State<TimeField> createState() => _TimeFieldState();
}

class _TimeFieldState extends State<TimeField> {
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    if (widget.initialTime != null) {
      _selectedTime = TimeOfDay.fromDateTime(widget.initialTime!);
    }
  }

  Future<void> _pickTime() async {
    final now = TimeOfDay.now();

    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFB388EB),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() => _selectedTime = picked);

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
          border: Border.all(
            color: const Color(0xFFB388EB),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: Color(0xFF8093F1)),
            const SizedBox(width: 12),
            Text(
              _displayText(),
              style: TextStyle(
                color:
                    _selectedTime == null ? Colors.grey : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}