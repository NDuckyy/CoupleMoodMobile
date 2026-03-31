import 'package:couple_mood_mobile/models/reset_password_request.dart';
import 'package:couple_mood_mobile/providers/auth_provider.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  bool obscure1 = true;
  bool obscure2 = true;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDC5F5), Color(0xFFB388EB), Color(0xFF72DDF7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Đổi mật khẩu",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text("OTP đã được gửi đến ${widget.email}"),

                  const SizedBox(height: 20),

                  // OTP
                  TextField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      hintText: "Nhâp OTP",
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: newPassController,
                    obscureText: obscure1,
                    decoration: InputDecoration(
                      hintText: "Mật khẩu mới",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure1 ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() => obscure1 = !obscure1);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: confirmPassController,
                    obscureText: obscure2,
                    decoration: InputDecoration(
                      hintText: "Xác nhận mật khẩu",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure2 ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() => obscure2 = !obscure2);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: provider.isLoading
                        ? null
                        : () async {
                            if (otpController.text.length != 6) {
                              showMsg(context, "OTP không hợp lệ", false);
                              return;
                            }

                            if (newPassController.text !=
                                confirmPassController.text) {
                              showMsg(context, "Mật khẩu không khớp", false);
                              return;
                            }

                            final request = ResetPasswordRequest(
                              email: widget.email,
                              otpCode: otpController.text,
                              newPassword: newPassController.text,
                              confirmPassword: confirmPassController.text,
                            );

                            await provider.resetPassword(request);

                            if (provider.error == null && context.mounted) {
                              showMsg(context, "Đổi mật khẩu thành công", true);
                              context.goNamed("login");
                            }
                          },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFDC5F5),
                            Color(0xFFB388EB),
                            Color(0xFF72DDF7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: provider.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Đổi mật khẩu",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  if (provider.error != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      provider.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
