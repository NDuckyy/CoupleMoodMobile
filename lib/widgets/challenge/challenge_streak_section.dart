import 'package:flutter/material.dart';

class StreakSection extends StatelessWidget {
  final int coupleStreak;
  final int memberStreak;

  const StreakSection({
    super.key,
    required this.coupleStreak,
    required this.memberStreak,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Chuỗi điểm danh",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            const Icon(Icons.local_fire_department, color: Colors.orange),

            const SizedBox(width: 6),

            Text("Chuỗi cặp đôi: $coupleStreak days"),
          ],
        ),

        const SizedBox(height: 6),

        Row(
          children: [
            const Icon(Icons.favorite, color: Colors.red),

            const SizedBox(width: 6),

            Text("Chuỗi cá nhân: $memberStreak days"),
          ],
        ),
      ],
    );
  }
}
