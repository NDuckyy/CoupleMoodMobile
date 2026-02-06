import 'package:couple_mood_mobile/widgets/custom_test_field.dart';
import 'package:flutter/material.dart';

class BudgetInput extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const BudgetInput({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: 'Ngân sách',
      hint: 'VND',
      icon: Icons.attach_money,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
    );
  }
}
