import 'package:flutter/material.dart';

Widget inputSection(
  TextEditingController c,
  String hint, {
  TextInputType? type,
  String? suffix,
  String? Function(String?)? validator,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    child: TextFormField(
      controller: c,
      keyboardType: type,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: hint,
        suffixText: suffix,
        filled: true,
        fillColor: const Color(0xFFF5F6FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}
