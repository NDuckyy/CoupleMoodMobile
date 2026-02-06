import 'package:couple_mood_mobile/widgets/custom_test_field.dart';
import 'package:flutter/material.dart';

class NoteInput extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const NoteInput({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: 'Ghi chú',
      hint: 'Mô tả buổi hẹn',
      icon: Icons.notes,
      maxLines: 4,
      onChanged: onChanged,
    );
  }
}
