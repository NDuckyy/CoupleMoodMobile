import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeHeader extends StatelessWidget {
  final int currentStreak;
  final bool hasCheckedInToday;
  const HomeHeader({
    super.key,
    required this.currentStreak,
    required this.hasCheckedInToday,
  });

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

        if (hasCheckedInToday) ...[
          Row(
            children: [
              const Icon(
                Icons.local_fire_department,
                size: 25,
                color: Colors.orange,
              ),
              const SizedBox(width: 4),
              Text(
                '$currentStreak ngày',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ] else ...[
          Row(
            children: [
              const Icon(
                Icons.local_fire_department,
                size: 25,
                color: Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                '$currentStreak ngày',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],

        const SizedBox(width: 8),

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
