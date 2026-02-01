import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class TestRiveScreen extends StatelessWidget {
  const TestRiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Rive Animation')),
      body: const Center(
        child: RiveAnimation.asset('lib/assets/animations/untitled.riv'),
      ),
    );
  }
}
