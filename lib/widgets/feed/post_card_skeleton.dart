import 'package:flutter/material.dart';

class PostCardSkeleton extends StatefulWidget {
  const PostCardSkeleton({super.key});

  @override
  State<PostCardSkeleton> createState() => _PostCardSkeletonState();
}

class _PostCardSkeletonState extends State<PostCardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _animation = Tween<double>(begin: -1, end: 2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _shimmerBox({double height = 12, double width = double.infinity}) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment(-1 + _animation.value, 0),
              end: Alignment(1 + _animation.value, 0),
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade100,
                Colors.grey.shade300,
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: _SkeletonContent(),
      ),
    );
  }
}

class _SkeletonContent extends StatelessWidget {
  const _SkeletonContent();

  Widget _box(double h, {double w = double.infinity}) {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// header
        Row(
          children: [
            _box(40, w: 40),
            const SizedBox(width: 10),
            Expanded(child: _box(12)),
          ],
        ),

        const SizedBox(height: 12),

        _box(12),
        const SizedBox(height: 6),
        _box(12, w: 200),

        const SizedBox(height: 12),

        _box(180),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [_box(20, w: 40), _box(20, w: 40), _box(20, w: 40)],
        ),
      ],
    );
  }
}
