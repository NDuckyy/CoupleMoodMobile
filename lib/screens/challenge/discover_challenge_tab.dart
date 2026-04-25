import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/challenge/challenge_provider.dart';
import '../../../providers/challenge/challenge_detail_provider.dart';
import '../../../screens/challenge/challenge_detail_screen.dart';
import '../../../widgets/challenge/challenge_card.dart';
import '../../../widgets/challenge/animated_challenge_item.dart';
import '../../../widgets/snack_bar.dart';

class DiscoverChallengesTab extends StatelessWidget {
  const DiscoverChallengesTab({super.key});

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

        final list = provider.discoverChallenges;

        return RefreshIndicator(
          onRefresh: provider.loadChallenges,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: list.isEmpty
                ? [emptyText("Bạn đã nhận hết challenge hôm nay 🎉")]
                : list.map((c) {
                    final isCheckin = c.triggerEvent == "CHECKIN";

                    return AnimatedChallengeItem(
                      key: ValueKey("discover_${c.id}"),
                      onAction: isCheckin
                          ? null
                          : () async {
                              final success = await provider.joinChallenge(
                                c.id,
                              );

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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChangeNotifierProvider(
                                  create: (_) => ChallengeDetailProvider(),
                                  child: ChallengeDetailScreen(template: c),
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
