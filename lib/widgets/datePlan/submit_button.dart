import 'package:couple_mood_mobile/providers/date_plan_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  const SubmitButton({super.key, required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    final datePlanProvider = context.watch<DatePlanProvider>();
    return datePlanProvider.isUpdateDatePlanLoading
        ? SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8093F1).withOpacity(0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const CircularProgressIndicator(color: Colors.white),
            ),
          )
        : SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8093F1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          );
  }
}
