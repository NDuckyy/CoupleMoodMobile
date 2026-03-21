import 'package:couple_mood_mobile/providers/challenge/challenge_provider.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/challenge/challenge_item.dart';
import '../../models/challenge/couple_challenge.dart';
import '../../providers/challenge/challenge_detail_provider.dart';

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

    final title = progress?.title ?? challenge?.title ?? "";
    final description = progress?.description ?? challenge?.description ?? "";

    final reward = progress?.rewardPoints ?? challenge?.rewardPoints ?? 0;

    final current = progress?.currentProgress ?? 0;

    final target = progress?.targetProgress ?? challenge?.targetGoal ?? 0;

    final trigger = progress?.triggerEvent ?? challenge?.triggerEvent ?? "";

    final progressExtra = progress?.progressExtra;

    final instructions =
        progress?.instructions ?? challenge?.instructions ?? [];

    if (provider.isLoading && challenge == null && progress == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(title: const Text("Chi tiết thử thách"), elevation: 0),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          /// TITLE
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            description,
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),

          const SizedBox(height: 20),

          /// REWARD
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.favorite, color: Colors.orange.shade600),

                const SizedBox(width: 8),

                Text(
                  "$reward Love Points",
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// MEMBERS
          if (progress != null) ...[
            const Text(
              "Người tham gia",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            CoupleParticipants(
              members: progress.members ?? [],
              trigger: trigger,
            ),

            const SizedBox(height: 24),
          ],

          /// PROGRESS
          if (isJoined && trigger != "CHECKIN") ...[
            const Text(
              "Progress",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            ChallengeProgressBar(current: current, target: target),

            const SizedBox(height: 6),

            Text("$current / $target"),

            const SizedBox(height: 24),
          ],

          /// CHECKIN TODAY
          if (trigger == "CHECKIN" && progressExtra != null) ...[
            TodayProgress(
              done: progressExtra['doneMembersToday'] ?? 0,
              total: progressExtra['totalMembers'] ?? 0,
            ),

            const SizedBox(height: 24),
          ],

          /// PROGRESS TEXT
          if ((progress?.progressText ?? "").isNotEmpty) ...[
            const SizedBox(height: 6),

            Text(
              progress!.progressText!,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ],

          /// STREAK
          if (trigger == "CHECKIN" && progressExtra != null) ...[
            StreakSection(
              coupleStreak: progressExtra['coupleCurrentStreak'] ?? 0,
              memberStreak: progressExtra['memberCurrentStreak'] ?? 0,
            ),

            const SizedBox(height: 24),
          ],

          /// RULES
          if (instructions.isNotEmpty) ...[
            const Text("Rules", style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            ChallengeRules(instructions: instructions),

            const SizedBox(height: 24),
          ],

          /// ACTION
          /// ACTION
          if (!isJoined && challenge != null)
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  final provider = context.read<ChallengeProvider>();

                  final success = await provider.joinChallenge(challenge.id);

                  if (!context.mounted) return;

                  if (success) {
                    showMsg(context, "Đã tham gia thử thách 💜", true);

                    Navigator.pop(context); // quay về list
                  } else {
                    showMsg(context, "Không thể tham gia thử thách", false);
                  }
                },
                child: const Text("Tham gia thử thách"),
              ),
            ),

          if (isJoined && progress != null)
            SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: () async {
                  final provider = context.read<ChallengeProvider>();

                  final success = await provider.leaveChallenge(progress.id);

                  if (!context.mounted) return;

                  if (success) {
                    showMsg(context, "Đã rời thử thách", true);

                    Navigator.pop(context); // quay về list
                  } else {
                    showMsg(context, "Không thể rời thử thách", false);
                  }
                },
                child: const Text("Leave Challenge"),
              ),
            ),
        ],
      ),
    );
  }
}
