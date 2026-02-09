import 'package:flutter/material.dart';

class VenueAddress extends StatelessWidget {
  final String address;

  const VenueAddress({required this.address, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.location_on_rounded,
          size: 18,
          color: Color(0xFF72DDF7),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            address,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF8093F1),
            ),
          ),
        ),
      ],
    );
  }
}
