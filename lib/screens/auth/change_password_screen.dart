import 'package:couple_mood_mobile/models/change_password_request.dart';
import 'package:couple_mood_mobile/providers/auth_provider.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final currentController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();

  bool obscureCurrent = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<AuthProvider>();

    await provider.changePassword(
      ChangePasswordRequest(
        currentPassword: currentController.text.trim(),
        newPassword: newController.text.trim(),
        confirmPassword: confirmController.text.trim(),
      ),
    );

    if (provider.error == null) {
      if (!mounted) return;
      showMsg(context, "Đổi mật khẩu thành công", true);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text("Đổi mật khẩu"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildPasswordField(
                controller: currentController,
                label: "Mật khẩu hiện tại",
                obscure: obscureCurrent,
                toggle: () =>
                    setState(() => obscureCurrent = !obscureCurrent),
              ),

              const SizedBox(height: 16),

              _buildPasswordField(
                controller: newController,
                label: "Mật khẩu mới",
                obscure: obscureNew,
                toggle: () =>
                    setState(() => obscureNew = !obscureNew),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Vui lòng nhập mật khẩu mới";
                  }
                  if (value.length < 6) {
                    return "Mật khẩu phải ít nhất 6 ký tự";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildPasswordField(
                controller: confirmController,
                label: "Xác nhận mật khẩu",
                obscure: obscureConfirm,
                toggle: () =>
                    setState(() => obscureConfirm = !obscureConfirm),
                validator: (value) {
                  if (value != newController.text) {
                    return "Mật khẩu xác nhận không khớp";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // ERROR
              if (provider.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    provider.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              // BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: provider.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Color(0xFFB388EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: provider.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Đổi mật khẩu",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback toggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return "Không được để trống";
            }
            return null;
          },
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        suffixIcon: IconButton(
          icon: Icon(
              obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: toggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}