import 'package:couple_mood_mobile/providers/test_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      _getPersonalityType(context.read<TestProvider>());
    });
  }

  Future<void> _loadTests(TestProvider testProvider) async {
    await testProvider.fetchTestList();
    if (!mounted) return;
  }

  Future<void> _getPersonalityType(TestProvider testProvider) async {
    await testProvider.getMyPersonalityType();
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    final testProvider = context.watch<TestProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Danh sách bài kiểm tra tính cách',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: const Color(0xFFFDFDFD),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 26),
            child: GestureDetector(
              onTap: () => context.pushNamed('test_history'),
              child: const Icon(Icons.history, color: Colors.black87),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF7F0FF),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: testProvider.isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: testProvider.tests.data?.length ?? 0,
                itemBuilder: (context, index) {
                  final test = testProvider.tests.data![index];

                  return GestureDetector(
                    onTap: () {
                      context.pushNamed(
                        'test_detail',
                        extra: {'testId': test.id},
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),

                        color: const Color(0xFFB388EB),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  test.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  test.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.85),
                                    fontSize: 14,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${test.totalQuestions} câu hỏi',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 10),

                          const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: 28,
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
