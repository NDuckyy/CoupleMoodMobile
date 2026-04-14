import 'package:flutter/material.dart';

class TodayProgress extends StatelessWidget {
  final int done;
  final int total;

  const TodayProgress({super.key, required this.done, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.today, size: 18),

        const SizedBox(width: 6),

        Text(
          "$done / $total đã hoàn thành hôm nay",
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }
}
