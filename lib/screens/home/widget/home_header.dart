import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Center(
          child: Text(
            'COUPLE MOOD',
            style: GoogleFonts.balooChettan2(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 56,
          child: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_outlined,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
