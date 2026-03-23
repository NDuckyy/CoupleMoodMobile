import 'package:flutter/material.dart';

class ProfileSummarySkeleton extends StatelessWidget {
  const ProfileSummarySkeleton({super.key});

  Widget box(double h, {double w = double.infinity}) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          /// Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 16),

          /// Text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              box(14, w: 120),
              const SizedBox(height: 8),
              box(12, w: 80),
            ],
          ),
        ],
      ),
    );
  }
}
