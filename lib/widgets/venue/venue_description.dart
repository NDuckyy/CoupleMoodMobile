import 'package:flutter/material.dart';

class VenueDescription extends StatelessWidget {
  final String description;

  const VenueDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
    );
  }
}
