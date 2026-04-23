import 'package:flutter/material.dart';

class GenderPickerField extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const GenderPickerField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Giới tính", style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),

        Row(
          children: [
            _GenderOption(
              label: "Nam",
              value: "MALE",
              groupValue: value,
              onChanged: onChanged,
            ),
            const SizedBox(width: 10),
            _GenderOption(
              label: "Nữ",
              value: "FEMALE",
              groupValue: value,
              onChanged: onChanged,
            ),
          ],
        ),
      ],
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  const _GenderOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? const Color(0xFFB388EB) : Colors.grey.shade200,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
