import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
              color: Colors.white,
            ),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 56,
          child: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                context.pushNamed('notification');
              },
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
