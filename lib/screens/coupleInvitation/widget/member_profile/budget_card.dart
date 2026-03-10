import 'package:couple_mood_mobile/utils/currency_utils.dart';
import 'package:flutter/material.dart';

class BudgetCard extends StatelessWidget {
  final double min;
  final double? max;

  const BudgetCard({super.key, required this.min, required this.max});

  @override
  Widget build(BuildContext context) {
    String budgetText;

    if (max == null) {
      budgetText = "Từ ${CurrencyUtils.formatVND(min)}";
    } else {
      budgetText = "${CurrencyUtils.formatRangeVND(min, max!)}";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFB388EB), Color(0xFF8093F1)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        budgetText,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
