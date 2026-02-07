import 'package:couple_mood_mobile/widgets/custom_test_field.dart';
import 'package:flutter/material.dart';

class BudgetInput extends StatelessWidget {
  final TextEditingController controller;

  const BudgetInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: 'Ngân sách',
      hint: 'Nhập ngân sách dự kiến',
      icon: Icons.payments_outlined,
      keyboardType: TextInputType.number,
      controller: controller,
    );
  }
}
