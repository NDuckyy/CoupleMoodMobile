import 'package:flutter/material.dart';
import '../../models/challenge/challenge_item.dart';
import '../../models/challenge/couple_challenge.dart';
import 'challenge_progress_bar.dart';

class ChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final int reward;
  final int? current;
  final int? target;
  final String? progressText;
  final bool completed;
  final VoidCallback? onJoin;
  final VoidCallback? onLeave;
  final VoidCallback? onTap;
  final VoidCallback? onClaimReward;
  final bool rewardClaimed;
  final String? triggerEvent;

  const ChallengeCard({
    super.key,
    required this.title,
    required this.description,
    required this.reward,
    this.current,
    this.target,
    this.progressText,
    this.completed = false,
    this.rewardClaimed = false,
    this.onJoin,
    this.onLeave,
    this.onClaimReward,
    this.onTap,
    this.triggerEvent,
  });

  /// Discover challenge
  factory ChallengeCard.discover(
    ChallengeItem item, {
    VoidCallback? onJoin,
    VoidCallback? onTap,
  }) {
    return ChallengeCard(
      title: item.title,
      description: item.description ?? "",
      reward: item.rewardPoints,
      onJoin: onJoin,
      onTap: onTap,
      triggerEvent: item.triggerEvent,
    );
  }

  /// In-progress challenge
  factory ChallengeCard.coupleChallenge(
    CoupleChallenge c, {
    VoidCallback? onTap,
  }) {
    return ChallengeCard(
      title: c.title,
      description: c.description,
      reward: c.rewardPoints,
      current: c.currentProgress,
      target: c.targetProgress,
      progressText: c.progressText,
      onTap: onTap,
    );
  }

  /// Completed challenge
  factory ChallengeCard.completed(CoupleChallenge c, {VoidCallback? onTap}) {
    return ChallengeCard(
      title: c.title,
      description: c.description,
      reward: c.rewardPoints,
      completed: true,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCheckin = triggerEvent == "CHECKIN";
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            /// DESCRIPTION
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),

            /// PROGRESS
            if (current != null && target != null) ...[
              const SizedBox(height: 14),

              ChallengeProgressBar(current: current!, target: target!),

              const SizedBox(height: 6),

              Text(
                progressText ?? "$current / $target",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],

            const SizedBox(height: 14),

            /// FOOTER
            Row(
              children: [
                /// Reward badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        size: 14,
                        color: Colors.orange.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "$reward",
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                /// Join button
                if (onJoin != null && !isCheckin)
                  SizedBox(
                    height: 34,
                    child: ElevatedButton.icon(
                      onPressed: onJoin,
                      icon: const Icon(Icons.play_arrow, size: 18),
                      label: const Text("Tham gia"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                /// Leave button
                if (onLeave != null && !isCheckin)
                  SizedBox(
                    height: 34,
                    child: OutlinedButton.icon(
                      onPressed: onLeave,
                      icon: const Icon(Icons.exit_to_app, size: 18),
                      label: const Text("Leave"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade600,
                        side: BorderSide(color: Colors.red.shade300),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                /// Completed
                /// CLAIM REWARD
                if (completed &&
                    !rewardClaimed &&
                    onClaimReward != null &&
                    !isCheckin)
                  SizedBox(
                    height: 34,
                    child: ElevatedButton.icon(
                      onPressed: onClaimReward,
                      icon: const Icon(Icons.card_giftcard, size: 18),
                      label: const Text("Nhận thưởng"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                /// REWARD CLAIMED
                if (completed && rewardClaimed && !isCheckin)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 14,
                          color: Colors.green.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Đã nhận thưởng",
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (completed && isCheckin)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 14,
                          color: Colors.green.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Đã hoàn thành",
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
