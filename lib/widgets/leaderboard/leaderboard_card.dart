import 'package:couple_mood_mobile/models/leaderboard/leaderboard_item.dart';
import 'package:flutter/material.dart';

enum LeaderboardCardType { silver, bronze, normal }

class LeaderboardCard extends StatelessWidget {
  final LeaderboardItem item;
  final LeaderboardCardType type;

  const LeaderboardCard({super.key, required this.item, required this.type});

  @override
  Widget build(BuildContext context) {
    final borderColor = switch (type) {
      LeaderboardCardType.silver => Colors.grey,
      LeaderboardCardType.bronze => Colors.brown,
      LeaderboardCardType.normal => Colors.pinkAccent,
    };

    final medalColor = switch (type) {
      LeaderboardCardType.silver => Colors.grey,
      LeaderboardCardType.bronze => Colors.brown,
      LeaderboardCardType.normal => null,
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            children: [
              /// RANK COLUMN (FIX CHUẨN)
              SizedBox(
                width: 36,
                child: Center(
                  child: medalColor != null
                      ? Icon(
                          Icons.workspace_premium,
                          color: medalColor,
                          size: 22,
                        )
                      : Text(
                          "${item.rankPosition}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),

              const SizedBox(width: 4),

              /// MEMBER 1
              Expanded(
                child: _MemberColumn(
                  avatar: item.member1.avatarUrl,
                  name: item.member1.memberName,
                ),
              ),

              /// CENTER
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.coupleName,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Icon(Icons.favorite, color: Colors.red, size: 18),
                  ],
                ),
              ),

              /// MEMBER 2
              Expanded(
                child: _MemberColumn(
                  avatar: item.member2.avatarUrl,
                  name: item.member2.memberName,
                ),
              ),
            ],
          ),

          ///  BADGE
          Positioned(
            right: -20,
            top: -22,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "${item.totalPoints} CP",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberColumn extends StatelessWidget {
  final String? avatar;
  final String name;

  const _MemberColumn({required this.avatar, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.grey[200],
          backgroundImage: avatar != null ? NetworkImage(avatar!) : null,
          child: avatar == null
              ? const Icon(Icons.person, size: 16, color: Colors.grey)
              : null,
        ),
        const SizedBox(height: 4),

        /// 🔥 FIX TEXT
        Text(
          name,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}
