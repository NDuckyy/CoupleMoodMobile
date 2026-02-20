import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MemberSearchHeader extends StatelessWidget {
  final int invitedCount;

  const MemberSearchHeader({super.key, required this.invitedCount});

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
          'Tìm kiếm người yêu',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(Icons.mail_outline, size: 28),
              onPressed: () {
                context.pushNamed('receive_invitation');
              },
            ),

            /// Badge
            if (invitedCount > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Center(
                    child: Text(
                      invitedCount > 99 ? '99+' : invitedCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
