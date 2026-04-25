import 'package:flutter/material.dart';

class CommentItemSkeleton extends StatelessWidget {
  final int level;

  const CommentItemSkeleton({super.key, this.level = 1});

  @override
  Widget build(BuildContext context) {
    final double indent = (level - 1) * 20.0;

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

    return Padding(
      padding: EdgeInsets.only(left: indent, top: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 10),

          /// Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Bubble
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      box(10, w: 120),
                      const SizedBox(height: 6),
                      box(10),
                      const SizedBox(height: 4),
                      box(10, w: 180),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    box(10, w: 40),
                    const SizedBox(width: 16),
                    box(10, w: 50),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
