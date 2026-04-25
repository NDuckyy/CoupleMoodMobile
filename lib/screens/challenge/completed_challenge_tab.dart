import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/challenge/challenge_provider.dart';
import '../../../widgets/challenge/challenge_card.dart';
import '../../../widgets/snack_bar.dart';

class CompletedChallengesTab extends StatelessWidget {
  const CompletedChallengesTab({super.key});

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

        final list = provider.completedChallenges;

        return RefreshIndicator(
          onRefresh: provider.loadChallenges,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: list.isEmpty
                ? [emptyText("Hoàn thành thử thách để nhận thưởng 💜")]
                : list.map((c) {
                    return AnimatedScale(
                      key: ValueKey("completed_${c.id}"),
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutBack,
                      scale: 1,
                      child: ChallengeCard(
                        title: c.title,
                        description: c.description,
                        reward: c.rewardPoints,
                        completed: true,
                        triggerEvent: c.triggerEvent,
                        rewardClaimed: c.isRewardClaimed ?? false,
                        onClaimReward: () async {
                          final success = await provider.claimReward(c.id);

                          if (success && context.mounted) {
                            showMsg(context, "Đã nhận thưởng 💜", true);
                          }
                        },
                      ),
                    );
                  }).toList(),
          ),
        );
      },
    );
  }
}
