import 'package:flutter/material.dart';

class BackgroudAuthScreen extends StatelessWidget {
  final Widget child;

  const BackgroudAuthScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF7B3E9), // hồng
                Color(0xFFD4B6FF), // tím nhạt
                Color(0xFF9FB6FF), // xanh nhạt
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
        ),

        // Positioned(
        //   left: -80,
        //   top: -80,
        //   child: Container(
        //     width: 220,
        //     height: 220,
        //     decoration: BoxDecoration(
        //       color: const Color(0xFFB388EB).withOpacity(0.35),
        //       shape: BoxShape.circle,
        //     ),
        //   ),
        // ),

        // Positioned(
        //   right: -90,
        //   bottom: -90,
        //   child: Container(
        //     width: 260,
        //     height: 260,
        //     decoration: BoxDecoration(
        //       color: Colors.white.withOpacity(0.25),
        //       shape: BoxShape.circle,
        //     ),
        //   ),
        // ),
        child,
      ],
    );
  }
}
