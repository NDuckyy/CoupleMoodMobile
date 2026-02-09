import 'package:flutter/material.dart';

class ChooseLocationScreen extends StatefulWidget {
  const ChooseLocationScreen({super.key});

  @override
  State<ChooseLocationScreen> createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn địa điểm')),
      body: const Center(child: Text('Location Search Screen')),
    );
  }
}
