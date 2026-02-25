import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReceiveHeader extends StatelessWidget {
  const ReceiveHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        const Text(
          'Lời mời kết đôi',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(Icons.pending_actions_outlined, size: 28),
              onPressed: () {
                context.pushNamed('sent_invitation');
              },
            ),
          ],
        ),
      ],
    );
  }
}
