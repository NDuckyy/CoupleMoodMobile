import 'package:flutter/material.dart';

class VenueCoverSkeleton extends StatelessWidget {
  const VenueCoverSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(color: Colors.grey.shade300),
    );
  }
}
