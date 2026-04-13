import 'package:couple_mood_mobile/screens/test/widgets/testHistory/personality_card.dart';
import 'package:couple_mood_mobile/screens/test/widgets/testHistory/test_history_card.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:couple_mood_mobile/providers/test_provider.dart';

class TestHistoryScreen extends StatefulWidget {
  const TestHistoryScreen({super.key});

  @override
  State<TestHistoryScreen> createState() => _TestHistoryScreenState();
}

class _TestHistoryScreenState extends State<TestHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<TestProvider>().fetchTestHistory();
    });
  }

  void _navigateToTestResult(int testId, String status) async {
    final testProvider = context.read<TestProvider>();
    await testProvider.fetchTestResult(testId);
    if(status == "IN_PROGRESS") {
      if (!mounted) return;
      showMsg(context, "Bài test chưa có kết quả", false);
      return;
    }
    if (!mounted) return;
    context.pushNamed('test_result');
  }

  String formatDate(String date) {
    final dt = DateTime.parse(date).toLocal();
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TestProvider>();
    final data = provider.testHistoryPagination;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Lịch sử bài test"),
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<TestProvider>().fetchTestHistory(),
        child: provider.isLoading && data == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  PersonalityCard(),

                  const SizedBox(height: 16),

                  if (data == null || data.items.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Text("Chưa có dữ liệu"),
                      ),
                    )
                  else
                    ...data.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TestHistoryCard(
                          item: item,
                          onTap: () => _navigateToTestResult(item.id, item.status),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
