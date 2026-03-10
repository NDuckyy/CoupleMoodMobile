import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RiveAnimation.asset(
        'lib/assets/images/loading.riv',
      ),
    );
  }
}
