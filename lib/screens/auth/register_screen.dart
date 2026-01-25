import 'package:couple_mood_mobile/models/register_request.dart';
import 'package:couple_mood_mobile/providers/auth_provider.dart';
import 'package:couple_mood_mobile/routes/app_route.dart';
import 'package:couple_mood_mobile/widgets/backgroud_auth_screen.dart';
import 'package:couple_mood_mobile/widgets/google_login_button.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();
  final TextEditingController _fullNameCtrl = TextEditingController();
  final TextEditingController _phoneNumberCtrl = TextEditingController();
  final TextEditingController _dateOfBirthCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String _gender = 'MALE';

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _fullNameCtrl.dispose();
    _phoneNumberCtrl.dispose();
    _dateOfBirthCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900, 1, 1),
      lastDate: now,
    );

    if (picked == null) return;

    final formatted = DateFormat('yyyy-MM-dd').format(picked);
    setState(() {
      _dateOfBirthCtrl.text = formatted;
    });
  }

  void onRegister() async {
    if (_formKey.currentState?.validate() != true) return;

    final req = RegisterRequest(
      fullName: _fullNameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phoneNumber: _phoneNumberCtrl.text.trim(),
      dateOfBirth: _dateOfBirthCtrl.text.trim(),
      gender: _gender,
      password: _passwordCtrl.text,
      confirmPassword: _confirmPasswordCtrl.text,
    );

    final auth = context.read<AuthProvider>();
    final ok = await auth.register(req);
    if (ok) {
      if (!mounted) return;
      showMsg(context, "Đăng ký thành công. Vui lòng đăng nhập.", true);
      context.pushNamed("login");
      return;
    }
    if (!mounted) return;
    showMsg(context, "Đăng ký thất bại: ${auth.error}", false);
  }

  InputDecoration _decoration(String label) => InputDecoration(
    filled: true,
    fillColor: Colors.white,
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
  );

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BackgroudAuthScreen(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage('lib/assets/images/register.png'),
                          width: 100,
                          height: 100,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 24),
                          width: 330,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(
                                  255,
                                  147,
                                  146,
                                  146,
                                ).withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(3, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Đăng ký tài khoản',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFB388EB),
                                    ),
                                  ),
                                  const SizedBox(height: 25),

                                  TextFormField(
                                    controller: _fullNameCtrl,
                                    decoration: _decoration('Họ và tên'),
                                    validator: (value) =>
                                        (value == null || value.trim().isEmpty)
                                        ? 'Vui lòng nhập họ và tên'
                                        : null,
                                  ),
                                  const SizedBox(height: 16),

                                  TextFormField(
                                    controller: _emailCtrl,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: _decoration('Email'),
                                    validator: (value) {
                                      final v = value?.trim() ?? '';
                                      if (v.isEmpty)
                                        return 'Vui lòng nhập email';
                                      final emailRegex = RegExp(
                                        r'^[^@]+@[^@]+\.[^@]+$',
                                      );
                                      if (!emailRegex.hasMatch(v)) {
                                        return 'Vui lòng nhập email hợp lệ';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  TextFormField(
                                    controller: _phoneNumberCtrl,
                                    keyboardType: TextInputType.phone,
                                    decoration: _decoration('Số điện thoại'),
                                    validator: (value) {
                                      final v = value?.trim() ?? '';
                                      if (v.isEmpty) {
                                        return 'Vui lòng nhập số điện thoại';
                                      }
                                      final phoneRegex = RegExp(r'^\d{9,15}$');
                                      if (!phoneRegex.hasMatch(v)) {
                                        return 'Số điện thoại không hợp lệ';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  TextFormField(
                                    controller: _dateOfBirthCtrl,
                                    readOnly: true,
                                    decoration:
                                        _decoration(
                                          'Ngày sinh (yyyy-MM-dd)',
                                        ).copyWith(
                                          suffixIcon: IconButton(
                                            icon: const Icon(
                                              Icons.calendar_month,
                                            ),
                                            onPressed: _pickDateOfBirth,
                                          ),
                                        ),
                                    onTap: _pickDateOfBirth,
                                    validator: (value) {
                                      final v = value?.trim() ?? '';
                                      if (v.isEmpty) {
                                        return 'Vui lòng chọn ngày sinh';
                                      }
                                      final dobRegex = RegExp(
                                        r'^\d{4}-\d{2}-\d{2}$',
                                      );
                                      if (!dobRegex.hasMatch(v)) {
                                        return 'Ngày sinh phải đúng định dạng yyyy-MM-dd';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  DropdownButtonFormField<String>(
                                    value: _gender,
                                    decoration: _decoration('Giới tính'),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'MALE',
                                        child: Text('Nam'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'FEMALE',
                                        child: Text('Nữ'),
                                      ),
                                    ],
                                    onChanged: (val) {
                                      if (val == null) return;
                                      setState(() => _gender = val);
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  TextFormField(
                                    controller: _passwordCtrl,
                                    obscureText: _obscurePassword,
                                    decoration: _decoration('Mật khẩu')
                                        .copyWith(
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscurePassword
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                            ),
                                            onPressed: () => setState(() {
                                              _obscurePassword =
                                                  !_obscurePassword;
                                            }),
                                          ),
                                        ),
                                    validator: (value) {
                                      final v = value ?? '';
                                      if (v.isEmpty)
                                        return 'Vui lòng nhập mật khẩu';
                                      if (v.length < 6) {
                                        return 'Mật khẩu tối thiểu 6 ký tự';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  TextFormField(
                                    controller: _confirmPasswordCtrl,
                                    obscureText: _obscureConfirmPassword,
                                    decoration: _decoration('Xác nhận mật khẩu')
                                        .copyWith(
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscureConfirmPassword
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                            ),
                                            onPressed: () => setState(() {
                                              _obscureConfirmPassword =
                                                  !_obscureConfirmPassword;
                                            }),
                                          ),
                                        ),
                                    validator: (value) {
                                      final v = value ?? '';
                                      if (v.isEmpty) {
                                        return 'Vui lòng xác nhận mật khẩu';
                                      }
                                      if (v != _passwordCtrl.text) {
                                        return 'Mật khẩu xác nhận không khớp';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 24),

                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFFF7B3E9),
                                            Color(0xFFD4B6FF),
                                            Color(0xFF9FB6FF),
                                          ],
                                        ),
                                      ),
                                      child: ElevatedButton(
                                        onPressed: onRegister,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Đăng ký',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Đã có tài khoản ?',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context.pushNamed("login");
                                        },
                                        child: const Text(
                                          'Đăng nhập',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFFB388EB),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
