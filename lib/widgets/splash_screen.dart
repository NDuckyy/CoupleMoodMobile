import 'package:couple_mood_mobile/providers/auth_provider.dart';
import 'package:couple_mood_mobile/routes/app_route.dart';
import 'package:couple_mood_mobile/widgets/backgroud_auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    final token = context.read<AuthProvider>().session?.accessToken;
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      if (token != null && token.isNotEmpty) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        return;
      }
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroudAuthScreen(
        child: SafeArea(
          child: Center(
            child: Image(
              image: AssetImage('lib/assets/images/splash_screen.png'),
              width: 200,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}
