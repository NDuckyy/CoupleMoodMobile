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
  late ScrollController _scrollController;
  double _offset = 0;

  @override
  void initState() {
    super.initState();

    /// 🔥 SCROLL LISTENER
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _offset = _scrollController.offset;
        });
      });

    Future.microtask(() {
      context.read<LeaderboardProvider>().fetchLeaderboard(
        year: DateTime.now().year,
        month: 1,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LeaderboardProvider>();
    final screenHeight = MediaQuery.of(context).size.height;

    /// 🔥 PROGRESS ANIMATION (0 -> 1)
    final progress = Curves.easeOut.transform((_offset / 300).clamp(0.0, 1.0));

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 245, 247),
      appBar: AppBar(
        title: const Text("Bảng xếp hạng"),
        backgroundColor: const Color.fromARGB(255, 230, 70, 123),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                /// 🔥 BACKGROUND DYNAMIC
                Positioned(
                  top: screenHeight * (0.33 - 0.45 * progress),
                  left: -20,
                  right: -20,
                  child: Container(
                    height: screenHeight * (0.80 + 0.45 * progress),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFFD0DD), // đậm hơn nhẹ
                          Color(0xFFFFA9C2), // rõ depth hơn
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(
                        300 * (1 - progress), // tròn -> vuông
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withOpacity(0.1),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),

                /// 🔥 CONTENT
                SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),

                      /// TOP 1
                      if (provider.top3.isNotEmpty)
                        Top1Podium(item: provider.top3[0]),

                      const SizedBox(height: 16),

                      /// TOP 2,3
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
              ],
            ),
    );
  }
}
