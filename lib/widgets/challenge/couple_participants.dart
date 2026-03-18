import 'package:couple_mood_mobile/models/challenge/challenge_member.dart';
import 'package:flutter/material.dart';

class CoupleParticipants extends StatelessWidget {
  final List<ChallengeMember> members;
  final String trigger;

  const CoupleParticipants({
    super.key,
    required this.members,
    required this.trigger,
  });

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) return const SizedBox();

    /// CHECKIN → hiển thị cả 2 người
    if (trigger == "CHECKIN" && members.length >= 2) {
      final m1 = members[0];
      final m2 = members[1];

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _avatar(m1),

          const SizedBox(width: 16),

          const Icon(Icons.favorite, color: Colors.red, size: 30),

          const SizedBox(width: 16),

          _avatar(m2),
        ],
      );
    }

    /// Other challenge → chỉ hiển thị current user
    final me = members.firstWhere(
      (m) => m.isCurrentUser,
      orElse: () => members.first,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [_avatar(me)],
    );
  }

  Widget _avatar(ChallengeMember member) {
    final avatar = member.avatarUrl;

    final done = member.hasDoneToday || member.contributionCount > 0;

    return Column(
      children: [
        Stack(
          children: [
            /// Avatar + highlight current user
            Container(
              decoration: member.isCurrentUser
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.pink, width: 2),
                    )
                  : null,
              child: CircleAvatar(
                radius: 24,
                backgroundImage: avatar != null ? NetworkImage(avatar) : null,
                child: avatar == null ? const Icon(Icons.person) : null,
              ),
            ),

            /// Done indicator
            if (done)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 12, color: Colors.white),
                ),
              ),
          ],
        ),

        const SizedBox(height: 6),

        SizedBox(
          width: 70,
          child: Text(
            member.memberName,
            style: const TextStyle(fontSize: 11),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
