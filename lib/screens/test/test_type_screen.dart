import 'package:couple_mood_mobile/models/test.dart';
import 'package:couple_mood_mobile/providers/test_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestTypeScreen extends StatefulWidget {
  const TestTypeScreen({super.key});

  @override
  State<TestTypeScreen> createState() => _TestTypeScreenState();
}

class _TestTypeScreenState extends State<TestTypeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTests(context.read<TestProvider>());
    });
  }

  Future<void> _loadTests(TestProvider testProvider) async {
    await testProvider.fetchTestList();
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    final testProvider = context.watch<TestProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách bài test')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: testProvider.isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: testProvider.tests.length,
                itemBuilder: (context, index) {
                  final test = testProvider.tests[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F5FF),
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {

                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  test.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(test.description),
                                const SizedBox(height: 12),
                                Text(
                                  '${test.totalQuestions} câu hỏi',
                                  style: const TextStyle(
                                    color: Color(0xFF8CA9FF),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.chevron_right,
                            size: 28,
                            color: Color(0xFF8CA9FF),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
