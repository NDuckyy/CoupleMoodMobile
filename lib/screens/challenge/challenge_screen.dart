import 'package:couple_mood_mobile/providers/challenge/challenge_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/challenge/challenge_card.dart';
import '../../widgets/challenge/challenge_section.dart';
import '../../widgets/challenge/animated_challenge_item.dart';
import '../../widgets/snack_bar.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ChallengeProvider>().loadChallenges();
    });
  }

  Widget emptyText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(title: const Text("Challenges"), elevation: 0),
      body: Consumer<ChallengeProvider>(
        builder: (_, provider, __) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: provider.loadChallenges,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                /// YOUR CHALLENGES
                ChallengeSection(
                  title: "💪 Challenge của bạn",
                  children: provider.doingChallenges.isEmpty
                      ? [emptyText("Bạn chưa tham gia thử thách nào")]
                      : provider.doingChallenges.map((c) {
                          final isCheckin = c.triggerEvent == "CHECKIN";
                          final isCompleted = c.status == "COMPLETED";

                          return AnimatedChallengeItem(
                            key: ValueKey("doing_${c.id}"),
                            onAction: (!isCheckin && !isCompleted)
                                ? () async {
                                    final success = await provider
                                        .leaveChallenge(c.id);

                                    if (success && context.mounted) {
                                      showMsg(
                                        context,
                                        "Đã rời thử thách",
                                        true,
                                      );
                                    }

                                    return success;
                                  }
                                : null,
                            builder: (trigger) {
                              return ChallengeCard(
                                title: c.title,
                                description: c.description,
                                reward: c.rewardPoints,
                                current: c.currentProgress,
                                target: c.targetProgress,
                                progressText: c.progressText,
                                completed: isCompleted,
                                onLeave: (!isCheckin && !isCompleted)
                                    ? trigger
                                    : null,
                              );
                            },
                          );
                        }).toList(),
                ),

                const SizedBox(height: 24),

                /// DISCOVER
                ChallengeSection(
                  title: "🔥 Khám phá thử thách",
                  children: provider.discoverChallenges.isEmpty
                      ? [emptyText("Bạn đã nhận hết challenge hôm nay 🎉")]
                      : provider.discoverChallenges.map((c) {
                          final isCheckin = c.triggerEvent == "CHECKIN";

                          return AnimatedChallengeItem(
                            key: ValueKey("discover_${c.id}"),
                            onAction: isCheckin
                                ? null
                                : () async {
                                    final success = await provider
                                        .joinChallenge(c.id);

                                    if (success && context.mounted) {
                                      showMsg(
                                        context,
                                        "Đã tham gia thử thách 💜",
                                        true,
                                      );
                                    }
                                    return success;
                                  },
                            builder: (trigger) {
                              return ChallengeCard.discover(
                                c,
                                onJoin: isCheckin ? null : trigger,
                              );
                            },
                          );
                        }).toList(),
                ),

                const SizedBox(height: 24),

                /// COMPLETED
                ChallengeSection(
                  title: "🏆 Đã hoàn thành",
                  children: provider.completedChallenges.isEmpty
                      ? [emptyText("Hoàn thành thử thách để nhận thưởng 💜")]
                      : provider.completedChallenges.map((c) {
                          return AnimatedScale(
                            key: ValueKey("completed_${c.id}"),
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutBack,
                            scale: 1,
                            child: ChallengeCard.completed(c),
                          );
                        }).toList(),
                ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}
