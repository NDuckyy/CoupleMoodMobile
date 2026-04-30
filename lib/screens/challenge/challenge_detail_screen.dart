import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/challenge/challenge_provider.dart';
import '../../../providers/challenge/challenge_detail_provider.dart';
import '../../../widgets/snack_bar.dart';

import '../../models/challenge/challenge_item.dart';
import '../../models/challenge/couple_challenge.dart';
import '../../widgets/challenge/challenge_progress_bar.dart';
import '../../widgets/challenge/couple_participants.dart';
import '../../widgets/challenge/today_progress.dart';
import '../../widgets/challenge/challenge_streak_section.dart';
import '../../widgets/challenge/challenge_rules.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final ChallengeItem? template;
  final CoupleChallenge? coupleChallenge;

  const ChallengeDetailScreen({super.key, this.template, this.coupleChallenge});

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = context.read<ChallengeDetailProvider>();

      if (widget.template != null) {
        provider.loadChallenge(widget.template!.id);
      }
      if (widget.coupleChallenge != null) {
        provider.loadProgress(widget.coupleChallenge!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChallengeDetailProvider>();

    final challenge = provider.challenge ?? widget.template;
    final progress = provider.progress ?? widget.coupleChallenge;

    final isJoined = progress != null;
    final isCheckin =
        (progress?.triggerEvent ?? challenge?.triggerEvent ?? "") == "CHECKIN";

    final title = progress?.title ?? challenge?.title ?? "";
    final description = progress?.description ?? challenge?.description ?? "";
    final reward = progress?.rewardPoints ?? challenge?.rewardPoints ?? 0;

    final current = progress?.currentProgress ?? 0;
    final target = progress?.targetProgress ?? challenge?.targetGoal ?? 0;

    final instructions =
        progress?.instructions ?? challenge?.instructions ?? [];

    if (provider.isLoading && challenge == null && progress == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: const Text("Chi tiết thử thách"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 15.5,
                      height: 1.45,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Reward Card
            _buildRewardCard(reward),

            const SizedBox(height: 24),

            // Participants
            if (isJoined && progress != null) ...[
              const Text(
                "Người tham gia",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              CoupleParticipants(
                members: progress.members ?? [],
                trigger: progress.triggerEvent ?? "",
              ),
              const SizedBox(height: 28),
            ],

            // Progress Section
            if (isJoined && !isCheckin) ...[
              const Text(
                "Tiến trình hiện tại",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ChallengeProgressBar(current: current, target: target),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$current / $target",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "${target == 0 ? 0 : ((current / target) * 100).toInt()}%",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
            ],

            // Check-in Today & Streak
            if (isCheckin && progress?.progressExtra != null) ...[
              TodayProgress(
                done: progress!.progressExtra!['doneMembersToday'] ?? 0,
                total: progress.progressExtra!['totalMembers'] ?? 0,
              ),
              const SizedBox(height: 20),
              StreakSection(
                coupleStreak:
                    progress.progressExtra!['coupleCurrentStreak'] ?? 0,
                memberStreak:
                    progress.progressExtra!['memberCurrentStreak'] ?? 0,
              ),
              const SizedBox(height: 28),
            ],

            // Rules
            if (instructions.isNotEmpty) ...[
              const Text(
                "Quy tắc thử thách",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              ChallengeRules(instructions: instructions),
            ],

            const SizedBox(height: 40),

            // Action Button
            if (!isJoined && challenge != null)
              _buildJoinButton(context, challenge),

            // 2. Đã tham gia + CHƯA hoàn thành + Không phải check-in → Nút "Rời thử thách"
            if (isJoined &&
                progress != null &&
                !isCheckin &&
                !(progress.isCompleted ?? false)) // ← Quan trọng
              _buildLeaveButton(context, progress),

            // 3. Đã hoàn thành + CHƯA nhận thưởng → Nút "Nhận phần thưởng"
            if (isJoined &&
                progress != null &&
                (progress.isCompleted ?? false) &&
                !(progress.isRewardClaimed ?? false))
              _buildClaimRewardButton(context, progress),

            // 4. Đã hoàn thành + ĐÃ nhận thưởng → Hiển thị badge "Đã nhận thưởng"
            if (isJoined &&
                progress != null &&
                (progress.isCompleted ?? false) &&
                (progress.isRewardClaimed ?? false))
              _buildClaimedBadge(),
          ],
        ),
      ),
    );
  }

  // ==================== HELPER WIDGETS ====================

  Widget _buildRewardCard(int reward) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.favorite, color: Colors.deepOrange, size: 32),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Phần thưởng",
                style: TextStyle(fontSize: 13, color: Colors.deepOrange),
              ),
              Text(
                "$reward điểm",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJoinButton(BuildContext context, ChallengeItem challenge) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        onPressed: () async {
          final success = await context.read<ChallengeProvider>().joinChallenge(
            challenge.id,
          );
          if (!context.mounted) return;

          if (success) {
            showMsg(context, "Đã tham gia thử thách 💜", true);
            Navigator.pop(context, true);
          } else {
            showMsg(context, "Không thể tham gia thử thách", false);
          }
        },
        child: const Text(
          "Tham gia thử thách",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildLeaveButton(BuildContext context, CoupleChallenge progress) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red.shade600,
          side: BorderSide(color: Colors.red.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () async {
          final success = await context
              .read<ChallengeProvider>()
              .leaveChallenge(progress.id);
          if (!context.mounted) return;

          if (success) {
            showMsg(context, "Đã rời thử thách", true);
            Navigator.pop(context, true);
          } else {
            showMsg(context, "Không thể rời thử thách", false);
          }
        },
        child: const Text(
          "Rời thử thách",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // Nút Nhận thưởng
  Widget _buildClaimRewardButton(
    BuildContext context,
    CoupleChallenge progress,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange.shade600,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        icon: const Icon(Icons.card_giftcard_rounded),
        label: const Text(
          "Nhận phần thưởng",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        onPressed: () async {
          final success = await context.read<ChallengeProvider>().claimReward(
            progress.id,
          );
          if (!context.mounted) return;

          if (success) {
            showMsg(context, "Đã nhận thưởng thành công 💜", true);
            Navigator.pop(context, true);
          } else {
            showMsg(context, "Không thể nhận thưởng lúc này", false);
          }
        },
      ),
    );
  }

  // Badge "Đã nhận thưởng"
  Widget _buildClaimedBadge() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: Colors.green.shade600,
            size: 28,
          ),
          const SizedBox(width: 12),
          const Text(
            "Đã nhận thưởng",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
