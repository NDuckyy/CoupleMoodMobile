import 'package:couple_mood_mobile/models/leaderboard/yearmonth.dart';
import 'package:couple_mood_mobile/providers/leaderboard/leaderboard_provider.dart';
import 'package:couple_mood_mobile/widgets/leaderboard/leaderboard_card.dart';
import 'package:couple_mood_mobile/widgets/leaderboard/top1_podium.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:couple_mood_mobile/widgets/leaderboard/leaderboard_info_button.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late ScrollController _scrollController;
  double _offset = 0;
  late List<YearMonth> _months;
  late YearMonth _selected;

  @override
  void initState() {
    super.initState();

    _months = getLast12Months();
    _selected = _months.first;

    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _offset = _scrollController.offset;
        });
      });

    Future.microtask(() {
      context.read<LeaderboardProvider>().fetchLeaderboard(
        year: _selected.year,
        month: _selected.month,
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
    final isEmpty = provider.rankings.isEmpty;

    ///  PROGRESS ANIMATION (0 -> 1)
    final progress = Curves.easeOut.transform((_offset / 300).clamp(0.0, 1.0));

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 245, 247),
      appBar: AppBar(
        title: const Text("Bảng xếp hạng"),
        backgroundColor: const Color.fromARGB(255, 230, 70, 123),
        actions: const [LeaderboardInfoButton()],
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

                ///  CONTENT
                SingleChildScrollView(
                  controller: _scrollController,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: screenHeight),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.pink.withOpacity(0.2),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<YearMonth>(
                                  value: _selected,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 18,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                  items: _months.map((m) {
                                    return DropdownMenuItem(
                                      value: m,
                                      child: Text(m.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (value) async {
                                    if (value == null) return;

                                    setState(() => _selected = value);

                                    await context
                                        .read<LeaderboardProvider>()
                                        .fetchLeaderboard(
                                          year: value.year,
                                          month: value.month,
                                        );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        if (isEmpty)
                          SizedBox(
                            height: screenHeight * 0.6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.emoji_events_outlined,
                                  size: 64,
                                  color: Colors.pink.withOpacity(0.4),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  "Chưa có dữ liệu",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  "Thử chọn tháng khác nhé 💕",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black45,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else ...[
                          /// TOP 1
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
                        ],

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
