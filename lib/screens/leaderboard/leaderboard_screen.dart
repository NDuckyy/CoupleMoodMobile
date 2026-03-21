import 'package:couple_mood_mobile/providers/leaderboard/leaderboard_provider.dart';
import 'package:couple_mood_mobile/widgets/leaderboard/leaderboard_card.dart';
import 'package:couple_mood_mobile/widgets/leaderboard/top1_podium.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<LeaderboardProvider>().fetchLeaderboard(
        year: DateTime.now().year,
        // month: DateTime.now().month,
        month: 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LeaderboardProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFDECEF),
      appBar: AppBar(
        title: const Text("Hall of Fame"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  ///  TOP 1
                  if (provider.top3.isNotEmpty)
                    Top1Podium(item: provider.top3[0]),

                  const SizedBox(height: 16),

                  ///  TOP 2,3
                  ...provider.top3
                      .skip(1)
                      .map(
                        (e) => LeaderboardCard(
                          item: e,
                          type: e.rankPosition == 2
                              ? LeaderboardCardType.silver
                              : LeaderboardCardType.bronze,
                        ),
                      ),

                  /// TOP 4+
                  ...provider.others.map(
                    (e) => LeaderboardCard(
                      item: e,
                      type: LeaderboardCardType.normal,
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}
