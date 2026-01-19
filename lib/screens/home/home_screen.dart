import 'package:couple_mood_mobile/providers/auth_provider.dart';
import 'package:couple_mood_mobile/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _logout() {
    final auth = context.read<AuthProvider>();
    auth.logout();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the Home Screen!'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.moodChooseMethod);
              },
              child: Text('Choose Mood'),
            ),
            ElevatedButton(
              onPressed: () {
                _logout();
                Future.delayed(Duration(milliseconds: 1000), () {
                  if (!mounted) return;
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                });
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
