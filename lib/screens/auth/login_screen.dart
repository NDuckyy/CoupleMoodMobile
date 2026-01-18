import 'package:couple_mood_mobile/providers/auth_provider.dart';
import 'package:couple_mood_mobile/routes/app_route.dart';
import 'package:couple_mood_mobile/widgets/backgroud_auth_screen.dart';
import 'package:couple_mood_mobile/widgets/google_login_button.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _onLogin() async {
    if (_formKey.currentState?.validate() != true) return;

    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    final auth = context.read<AuthProvider>();
    print("screen");
    final ok = await auth.login(email, password);
    
    if (ok) {
      if (!mounted) return;
      showMsg(context, "Đăng nhập thành công", true);
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      showMsg(context, "Tên đăng nhập hoặc mật khẩu không đúng", false);
    }
  }

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
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Container(
                          //   width: 70,
                          //   height: 70,
                          //   decoration: const BoxDecoration(
                          //     color: Color(0xFFB388EB),
                          //     borderRadius: BorderRadius.all(
                          //       Radius.circular(12),
                          //     ),
                          //   ),
                          //   child: const Icon(
                          //     Icons.favorite,
                          //     color: Colors.white,
                          //     size: 40,
                          //   ),
                          // ),
                          Image.asset(
                            'lib/assets/images/logo.png',
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'COUPLE MOOD',
                            style: GoogleFonts.balooChettan2(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Chọn đúng mood, đi đúng chỗ',
                            style: GoogleFonts.balooChettan2(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),

                          Container(
                            width: 330,
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 26),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(40),
                              ),
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
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 20),
                                const Text(
                                  'Chào mừng trở lại',
                                  style: TextStyle(
                                    color: Color(0xFFB388EB),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Đăng nhập để tiếp tục',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                TextFormField(
                                  controller: _emailCtrl,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    label: const Text("Tên đăng nhập"),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 16,
                                    ),
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                      ? 'Vui lòng nhập tên đăng nhập'
                                      : null,
                                ),
                                const SizedBox(height: 16),

                                TextFormField(
                                  controller: _passwordCtrl,
                                  obscureText: _obscurePassword,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    label: const Text("Mật khẩu"),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 16,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                      ? 'Vui lòng nhập mật khẩu'
                                      : null,
                                ),
                                const SizedBox(height: 24),

                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        246,
                                        186,
                                        247,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _onLogin();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Đăng nhập',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.register,
                                    );
                                  },
                                  style:
                                      OutlinedButton.styleFrom(
                                        minimumSize: Size(double.infinity, 50),
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                          color: Color(0xFFB388EB),
                                        ),
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ).copyWith(
                                        overlayColor: WidgetStateProperty.all(
                                          Color(0xFFB388EB).withOpacity(0.2),
                                        ),
                                      ),
                                  child: const Text(
                                    'Đăng ký',
                                    style: TextStyle(
                                      color: Color(0xFFB388EB),
                                      fontSize: 20,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.black,
                                  ),
                                  onPressed: () {
                                    print("Quên mật khẩu");
                                  },
                                  child: const Text("Quên mật khẩu?"),
                                ),
                                const SizedBox(height: 10),
                                googleLoginButton(),
                              ],
                            ),
                          ),
                        ],
                      ),
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
