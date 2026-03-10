import 'package:couple_mood_mobile/widgets/custom_test_field.dart';
import 'package:flutter/material.dart';

class ReviewContentField extends StatelessWidget {
  final TextEditingController controller;

  const ReviewContentField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Text(
          "Nhận xét của bạn về địa điểm này",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 2),
        CustomTextField(
          controller: controller,
          maxLines: 4,
          hint: "Chia sẻ cảm nhận của bạn về địa điểm này nhé!",
          icon: Icons.note,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Vui lòng nhập nhận xét của bạn";
            }
            return null;
          },
        ),
      ],
    );
  }
}
