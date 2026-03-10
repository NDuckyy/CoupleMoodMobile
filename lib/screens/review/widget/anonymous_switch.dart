import 'package:flutter/material.dart';

class AnonymousSwitch extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;

  const AnonymousSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Đăng ẩn danh",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Switch(
          value: value,
          activeColor: const Color(0xFFB388EB),
          onChanged: onChanged,
        ),
      ],
    );
  }
}