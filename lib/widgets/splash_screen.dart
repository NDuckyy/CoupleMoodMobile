import 'package:couple_mood_mobile/routes/app_route.dart';
import 'package:couple_mood_mobile/widgets/backgroud_auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
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
