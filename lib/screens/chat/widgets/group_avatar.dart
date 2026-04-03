import 'package:couple_mood_mobile/models/chat/conversation_member.dart';
import 'package:flutter/material.dart';

class GroupAvatar extends StatelessWidget {
  final List<ConversationMember> members;
  final double size;

  const GroupAvatar({super.key, required this.members, this.size = 90});

  @override
  Widget build(BuildContext context) {
    final displayMembers = members.take(3).toList();

    double big = size;
    double medium = size * 0.55;
    double small = size * 0.45;

    Widget buildAvatar(String? url, String name, double s) {
      final hasImage = url != null && url.isNotEmpty;

      return Container(
        width: s,
        height: s,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        padding: EdgeInsets.all(s * 0.05),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: hasImage
                ? null
                : const LinearGradient(
                    colors: [Color(0xFFFDC5F5), Color(0xFFB388EB)],
                  ),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: hasImage ? NetworkImage(url) : null,
            child: !hasImage
                ? Text(
                    name[0].toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: s * 0.35,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
        ),
      );
    }

    // 1
    if (displayMembers.length == 1) {
      return buildAvatar(
        displayMembers[0].avatar,
        displayMembers[0].fullName ?? 'U',
        big,
      );
    }

    // 2
    if (displayMembers.length == 2) {
      return SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: size * 0.15,
              child: buildAvatar(
                displayMembers[0].avatar,
                displayMembers[0].fullName ?? 'U',
                medium,
              ),
            ),
            Positioned(
              right: 0,
              bottom: size * 0.15,
              child: buildAvatar(
                displayMembers[1].avatar,
                displayMembers[1].fullName ?? 'U',
                medium,
              ),
            ),
          ],
        ),
      );
    }

    // 3
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned(
            top: size * 0.05,
            left: size * 0.25,
            child: buildAvatar(
              displayMembers[0].avatar,
              displayMembers[0].fullName ?? 'U',
              small,
            ),
          ),
          Positioned(
            bottom: size * 0.1,
            left: 5,
            child: buildAvatar(
              displayMembers[1].avatar,
              displayMembers[1].fullName ?? 'U',
              small,
            ),
          ),
          Positioned(
            bottom: size * 0.1,
            right: 5,
            child: buildAvatar(
              displayMembers[2].avatar,
              displayMembers[2].fullName ?? 'U',
              small,
            ),
          ),
        ],
      ),
    );
  }
}
