import 'package:flutter/material.dart';

class EditDatePlanItemButton extends StatelessWidget {
  final VoidCallback onPressed;

  const EditDatePlanItemButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: const BorderSide(color: Color(0xFF8093F1), width: 2),
        ),
        child: const Center(
          child: Text(
            'Edit',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8093F1),
            ),
          ),
        ),
      ),
    );
  }
}
