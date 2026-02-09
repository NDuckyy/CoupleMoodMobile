import 'package:couple_mood_mobile/widgets/custom_test_field.dart';
import 'package:flutter/material.dart';

class TitleInput extends StatelessWidget {
  final TextEditingController controller;

  const TitleInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: 'Tiêu đề buổi hẹn',
      hint: 'Ví dụ: Dinner & Movie',
      icon: Icons.favorite,
      controller: controller,
    );
  }
}
