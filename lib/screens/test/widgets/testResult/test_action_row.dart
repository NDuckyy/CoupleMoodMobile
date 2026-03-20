import 'package:flutter/material.dart';

class TestActionsRow extends StatelessWidget {
  final VoidCallback onHome;
  final VoidCallback onBack;

  const TestActionsRow({required this.onHome, required this.onBack, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onHome,
            icon: const Icon(Icons.favorite, color: Colors.white),
            label: const Text(
              'Về trang chủ',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8093F1),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
            ),
          ),
        ),
      ],
    );
  }
}
