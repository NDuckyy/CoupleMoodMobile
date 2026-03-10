import 'package:flutter/material.dart';

class ChallengeProgressBar extends StatelessWidget {
  final int current;
  final int target;

  const ChallengeProgressBar({
    super.key,
    required this.current,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    double percent = target == 0 ? 0.0 : current / target;
    percent = percent.clamp(0.0, 1.0);

    final bool completed = percent >= 1;

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        tween: Tween(begin: 0, end: percent),
        builder: (context, value, _) {
          return LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(
              completed ? const Color(0xFF58CC02) : const Color(0xFFFFB020),
            ),
          );
        },
      ),
    );
  }
}
