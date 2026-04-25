import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboard;

  const ProfileInput({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboard,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        inputFormatters: keyboard == TextInputType.number
            ? [FilteringTextInputFormatter.digitsOnly]
            : null,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(14),
        ),
      ),
    );
  }
}
