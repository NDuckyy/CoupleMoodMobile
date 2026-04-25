import 'package:flutter/material.dart';

class TestButtons extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onSubmit;

  const TestButtons({
    super.key,
    required this.onSave,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          /// SAVE BUTTON
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB388EB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: onSave,
              child: const Text(
                'Lưu',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// SUBMIT BUTTON
          Expanded(
            flex: 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8093F1),
                elevation: 4,
                shadowColor: const Color(0xFF8093F1).withOpacity(0.4),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: onSubmit,
              child: const Text(
                'Nộp bài',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}