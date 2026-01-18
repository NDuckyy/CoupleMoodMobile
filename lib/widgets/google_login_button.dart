import 'package:flutter/material.dart';

Widget googleLoginButton() {
  return SizedBox(
    width: double.infinity,
    height: 48,
    child: OutlinedButton(
      onPressed: () {
        print("Đang nhập với Google");
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.g_mobiledata, size: 28, color: Colors.black87),
          const SizedBox(width: 12),
          const Text(
            'Đăng nhập với Google',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
