import 'package:flutter/material.dart';

class VenueDescription extends StatelessWidget {
  final String text;

  const VenueDescription({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFFB388EB),
        height: 1.4,
      ),
    );
  }
}
