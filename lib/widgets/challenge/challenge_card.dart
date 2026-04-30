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
    final hasProgress = current != null && target != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
          border: completed
              ? Border.all(color: Colors.green.shade300, width: 1.5)
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background subtle icon khi completed
              if (completed)
                Positioned(
                  top: -40,
                  right: -40,
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 130,
                    color: Colors.green.withOpacity(0.07),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: Icon + Title
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isCheckin
                                ? Colors.blue.shade50
                                : Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            isCheckin
                                ? Icons.calendar_today_rounded
                                : Icons.emoji_events_rounded,
                            color: isCheckin
                                ? Colors.blue.shade600
                                : Colors.orange.shade600,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              height: 1.25,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Description
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.4,
                        color: Colors.grey[700],
                      ),
                    ),

                    // Progress
                    if (hasProgress) ...[
                      const SizedBox(height: 16),
                      ChallengeProgressBar(current: current!, target: target!),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            progressText ?? "$current / $target",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            "${((current! / target!) * 100).toInt()}%",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 18),

                    // Footer: Reward + Action
                    Row(
                      children: [
                        // Reward
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.favorite,
                                size: 18,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "$reward",
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        // Buttons
                        if (onJoin != null && !isCheckin) _buildJoinButton(),

                        if (onLeave != null && !isCheckin) _buildLeaveButton(),

                        if (completed &&
                            !rewardClaimed &&
                            onClaimReward != null &&
                            !isCheckin)
                          _buildClaimRewardButton(),

                        if (completed && rewardClaimed && !isCheckin)
                          _buildClaimedBadge(),

                        if (completed && isCheckin) _buildCompletedBadge(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== BUTTON WIDGETS ====================

  Widget _buildJoinButton() {
    return SizedBox(
      height: 38,
      child: ElevatedButton.icon(
        onPressed: onJoin,
        icon: const Icon(Icons.play_arrow_rounded, size: 20),
        label: const Text(
          "Tham gia",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildLeaveButton() {
    return SizedBox(
      height: 38,
      child: OutlinedButton.icon(
        onPressed: onLeave,
        icon: const Icon(Icons.exit_to_app, size: 19),
        label: const Text("Rời khỏi"),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red.shade600,
          side: BorderSide(color: Colors.red.shade300),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildClaimRewardButton() {
    return SizedBox(
      height: 38,
      child: ElevatedButton.icon(
        onPressed: onClaimReward,
        icon: const Icon(Icons.card_giftcard, size: 20),
        label: const Text(
          "Nhận thưởng",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange.shade600,
          foregroundColor: Colors.white,
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildClaimedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 18, color: Colors.green.shade600),
          const SizedBox(width: 6),
          const Text(
            "Đã nhận thưởng",
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 18, color: Colors.green.shade600),
          const SizedBox(width: 6),
          const Text(
            "Đã hoàn thành",
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
