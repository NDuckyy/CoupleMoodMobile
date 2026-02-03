import 'package:couple_mood_mobile/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
                context.pushNamed("moodChooseMethod");
              },
              child: Text('Choose Mood'),
            ),

            ElevatedButton(
              onPressed: () {
                context.pushNamed("venue_detail");
              },
              child: Text('Venue Detail (Test id 1)'),
            ),

            ElevatedButton(
              onPressed: () {
                context.pushNamed("test");
              },
              child: Text('Go to Test Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                _logout();
                Future.delayed(Duration(milliseconds: 1000), () {
                  if (!mounted) return;
                  context.pushNamed("login");
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
