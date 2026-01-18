import 'package:flutter/material.dart';

class MoodFaceResultScreen extends StatefulWidget {
  const MoodFaceResultScreen({super.key});

  @override
  State<MoodFaceResultScreen> createState() => _MoodFaceResultScreenState();
}

class _MoodFaceResultScreenState extends State<MoodFaceResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Mood Face Result Screen')],
        ),
      ),
    );
  }
}
