import 'package:couple_mood_mobile/routes/app_route.dart';
import 'package:couple_mood_mobile/screens/auth/login_screen.dart';
import 'package:couple_mood_mobile/screens/auth/register_screen.dart';
import 'package:couple_mood_mobile/widgets/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      ),
      home: const SplashScreen(),
      routes: {
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
      },
    );
  }
}
