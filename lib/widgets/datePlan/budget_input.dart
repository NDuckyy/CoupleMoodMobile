import 'package:flutter/material.dart';
import 'package:couple_mood_mobile/utils/currency_utils.dart';

class BudgetInput extends StatelessWidget {
  final TextEditingController controller;

  const BudgetInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ngân sách',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [VNDInputFormatter()],
          validator: (v) {
            if (v == null || v.isEmpty) return null;

            final amount = CurrencyUtils.parseVND(v);

            if (amount < 10000) {
              return "Tối thiểu 10.000đ";
            }

            return null;
          },
          decoration: InputDecoration(
            prefixText: 'đ ',
            isDense: true,
            hintText: 'Nhập ngân sách dự kiến',
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFFB388EB),
                width: 1.2,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFF8093F1),
                width: 1.6,
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.6),
            ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
