import 'package:flutter/material.dart';

class EducationPickerField extends StatelessWidget {
  final String? value;
  final List<String> options;
  final Function(String) onChanged;

  const EducationPickerField({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  Future<void> _openPicker(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const Text(
                "Chọn học vấn",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              ...options.map((e) {
                final isSelected = value == e;

                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: Text(e),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Color(0xFFB388EB))
                      : null,
                  onTap: () {
                    Navigator.pop(context, e);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );

    if (result != null) {
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPicker(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6FA),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value ?? "Chọn học vấn",
              style: TextStyle(
                color: value == null ? Colors.grey : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}