import 'package:couple_mood_mobile/widgets/custom_test_field.dart';
import 'package:flutter/material.dart';

class NoteInput extends StatelessWidget {
  final TextEditingController controller;

  const NoteInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: 'Ghi chú',
      hint: 'Nhập ghi chú cho kế hoạch hẹn hò',
      icon: Icons.note_alt_outlined,
      keyboardType: TextInputType.text,
      controller: controller,
      maxLines: 4,
    );
  }
}
