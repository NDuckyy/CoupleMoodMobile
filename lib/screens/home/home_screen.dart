import 'package:couple_mood_mobile/routes/app_route.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          ],
        ),
      ),
    );
  }
}
