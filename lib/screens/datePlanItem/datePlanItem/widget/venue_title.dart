import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VenueTitle extends StatelessWidget {
  final String name;
  final int venueId;

  const VenueTitle({required this.name, required this.venueId, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      splashColor: const Color(0xFF72DDF7).withOpacity(0.3),
      highlightColor: const Color(0xFFF7AEF8).withOpacity(0.3),
      onTap: () => {
        context.pushNamed("venue_detail", extra: {"venueId": venueId}),
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          name,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
