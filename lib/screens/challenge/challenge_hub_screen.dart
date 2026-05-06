import 'package:couple_mood_mobile/screens/challenge/completed_challenge_tab.dart';
import 'package:couple_mood_mobile/screens/challenge/discover_challenge_tab.dart';
import 'package:couple_mood_mobile/screens/challenge/doing_challenge_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/challenge/challenge_provider.dart';

class ChallengeHubScreen extends StatefulWidget {
  final int initialTab;

  const ChallengeHubScreen({super.key, this.initialTab = 0});

  @override
  State<ChallengeHubScreen> createState() => _ChallengeHubScreenState();
}

class _ChallengeHubScreenState extends State<ChallengeHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTab,
    );

    /// load 1 lần duy nhất
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChallengeProvider>().loadChallenges();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Thử thách"),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Khám phá"),
            Tab(text: "Đang làm"),
            Tab(text: "Hoàn thành"),
          ],
        ),
      ),
      body: Container(
        color: const Color(0xFFF7F7F7),
        child: TabBarView(
          controller: _tabController,
          children: const [
            DiscoverChallengesTab(),
            DoingChallengesTab(),
            CompletedChallengesTab(),
          ],
        ),
      ),
    );
  }
}
