import 'package:couple_mood_mobile/screens/test/widgets/testHistory/personality_card.dart';
import 'package:couple_mood_mobile/screens/test/widgets/testHistory/test_history_card.dart';
import 'package:flutter/material.dart';
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
      context.read<TestProvider>().fetchTestHistory();
    });
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
      body: provider.isLoading && data == null
          ? const Center(child: CircularProgressIndicator())
          : data == null || data.items.isEmpty
          ? const Center(child: Text("Chưa có dữ liệu"))
          : RefreshIndicator(
              onRefresh: () => context.read<TestProvider>().fetchTestHistory(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  PersonalityCard(),

                  const SizedBox(height: 16),

                  ...data.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TestHistoryCard(item: item),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
