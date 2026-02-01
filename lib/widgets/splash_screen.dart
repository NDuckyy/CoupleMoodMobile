import 'package:couple_mood_mobile/providers/auth_provider.dart';
import 'package:couple_mood_mobile/widgets/backgroud_auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

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
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      if (token != null && token.isNotEmpty) {
        context.goNamed("home");
        return;
      }
      context.goNamed("login");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroudAuthScreen(
        child: SafeArea(
          child: Center(
            child: SizedBox(
              child: RiveAnimation.asset('lib/assets/images/Splash.riv'),
            ),
          ),
        ),
      ),
    );
  }
}
