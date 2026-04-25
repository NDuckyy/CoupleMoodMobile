import 'package:couple_mood_mobile/providers/auth_provider.dart';
import 'package:couple_mood_mobile/services/google_service.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Widget googleLoginButton(BuildContext context) {
  final googleAuthService = GoogleAuthService();
  final authProvider = context.read<AuthProvider>();
  return SizedBox(
    width: double.infinity,
    height: 48,
    child: OutlinedButton(
      onPressed: () async {
        final idToken = await googleAuthService.signInAndGetIdToken();
        if (idToken == null) {
          return;
        }
        try {
          final success = await authProvider.loginWithGoogle(idToken);
          if (!success) {
            if (!context.mounted) {
              return;
            }
            showMsg(context, "Đăng nhập thất bại. Vui lòng thử lại.", false);
          } else {
            if (!context.mounted) {
              return;
            }
            showMsg(context, "Đăng nhập thành công!", true);
            Future.delayed(const Duration(seconds: 1), () {
              if (!context.mounted) {
                return;
              }
              context.goNamed('home');
            });
          }
        } catch (e) {
          if (!context.mounted) {
            return;
          }
          showMsg(context, "Đăng nhập thất bại. Vui lòng thử lại.", false);
        }
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
