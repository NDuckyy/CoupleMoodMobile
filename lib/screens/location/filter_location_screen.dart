import 'package:flutter/material.dart';

class FilterLocationScreen extends StatefulWidget {
  const FilterLocationScreen({super.key});

  @override
  State<FilterLocationScreen> createState() => _FilterLocationScreenState();
}

class _FilterLocationScreenState extends State<FilterLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bộ lọc địa điểm'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Filter Location Screen'),
      ),
    );
  }
}