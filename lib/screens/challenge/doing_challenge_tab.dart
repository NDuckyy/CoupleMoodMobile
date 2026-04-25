import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/challenge/challenge_provider.dart';
import '../../../providers/challenge/challenge_detail_provider.dart';
import '../../../screens/challenge/challenge_detail_screen.dart';
import '../../../widgets/challenge/challenge_card.dart';
import '../../../widgets/challenge/animated_challenge_item.dart';
import '../../../widgets/snack_bar.dart';

class DoingChallengesTab extends StatelessWidget {
  const DoingChallengesTab({super.key});

  Widget emptyText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(text, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChallengeProvider>(
      builder: (_, provider, __) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final list = provider.doingChallenges;

        return RefreshIndicator(
          onRefresh: provider.loadChallenges,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: list.isEmpty
                ? [emptyText("Bạn chưa tham gia thử thách nào")]
                : list.map((c) {
                    final isCheckin = c.triggerEvent == "CHECKIN";
                    final isCompleted = c.status == "COMPLETED";

                    return AnimatedChallengeItem(
                      key: ValueKey("doing_${c.id}"),
                      onAction: (!isCheckin && !isCompleted)
                          ? () async {
                              final success = await provider.leaveChallenge(
                                c.id,
                              );

                              if (success && context.mounted) {
                                showMsg(context, "Đã rời thử thách", true);
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
                          triggerEvent: c.triggerEvent,
                          onLeave: (!isCheckin && !isCompleted)
                              ? trigger
                              : null,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChangeNotifierProvider(
                                  create: (_) => ChallengeDetailProvider(),
                                  child: ChallengeDetailScreen(
                                    coupleChallenge: c,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }).toList(),
          ),
        );
      },
    );
  }
}
