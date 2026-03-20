import 'package:couple_mood_mobile/models/test/test_submit.dart';
import 'package:couple_mood_mobile/providers/test_provider.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

const primary = Color(0xFFB388EB);
const softPink = Color(0xFFFFF1F8);
const softGrey = Color(0xFFF5F5F7);

class TestDetailScreen extends StatefulWidget {
  const TestDetailScreen({super.key});

  @override
  State<TestDetailScreen> createState() => _TestDetailScreenState();
}

class _TestDetailScreenState extends State<TestDetailScreen> {
  Map<int, String?> selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initTestFlow();
    });
  }

  Future<void> _initTestFlow() async {
    final testProvider = context.read<TestProvider>();
    final GoRouterState state = GoRouterState.of(context);
    final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
    final testId = extra['testId'];

    final testState = await testProvider.checkStateTest(testId);

    if (!mounted) return;

    if (testState == 'NEW') {
      await testProvider.fetchTestDetails(testId, 'NEW');
    } else if (testState == 'IN_PROGRESS') {
      await _showResumeDialog(
        onContinue: () async {
          await testProvider.fetchTestDetails(testId, 'IN_PROGRESS');
          if (!mounted) return;
          _initSelectedAnswers();
        },
        onRestart: () async {
          await testProvider.fetchTestDetails(testId, 'NEW');
        },
      );
    }
  }

  Future<void> _showResumeDialog({
    required VoidCallback onContinue,
    required VoidCallback onRestart,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Bài test chưa hoàn thành'),
          content: const Text(
            'Bạn đang làm dở bài test này. Bạn muốn tiếp tục hay làm lại từ đầu?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRestart();
              },
              child: const Text('Làm mới'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onContinue();
              },
              child: const Text('Tiếp tục'),
            ),
          ],
        );
      },
    );
  }

  List<UserAnswer> buildAnswerPayload() {
    List<UserAnswer> answers = [];
    selectedAnswers.forEach((questionId, answerId) {
      answers.add(
        UserAnswer(questionId: questionId.toString(), answerId: answerId!),
      );
    });
    return answers;
  }

  Future<void> _initSelectedAnswers() async {
    selectedAnswers.clear();

    for (final question in context.read<TestProvider>().testDetails.data!) {
      for (final option in question.options) {
        if (option.isSelected == true) {
          selectedAnswers[question.questionId] = option.answerId.toString();
          break;
        }
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final TestProvider testProvider = context.watch<TestProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Bài test 💕',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB388EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  final provider = context.read<TestProvider>();

                  TestSubmit answers = TestSubmit(
                    action: "SAVE_PROGRESS",
                    currentQuestionIndex: 0,
                    answers: buildAnswerPayload(),
                  );

                  try {
                    final state = GoRouterState.of(context);
                    final testId =
                        (state.extra as Map<String, dynamic>)['testId'];

                    await provider.submitTestAnswers(testId, answers);
                    if (!context.mounted) return;
                    showMsg(context, "Đã lưu tiến trình", true);
                    context.pop();
                  } catch (_) {
                    if (!context.mounted) return;
                    showMsg(context, "Lỗi khi lưu tiến trình", false);
                  }
                },
                child: const Text('Lưu', style: TextStyle(color: Colors.white)),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              flex: 2,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8093F1),
                  elevation: 4,
                  shadowColor: const Color(0xFF8093F1).withOpacity(0.4),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                  final provider = context.read<TestProvider>();

                  TestSubmit answers = TestSubmit(
                    action: "SUBMIT",
                    currentQuestionIndex: 0,
                    answers: buildAnswerPayload(),
                  );

                  try {
                    final state = GoRouterState.of(context);
                    final testId =
                        (state.extra as Map<String, dynamic>)['testId'];

                    await provider.submitTestAnswers(testId, answers);
                    if (!context.mounted) return;

                    if (provider.error != null) {
                      showMsg(context, provider.error!, false);
                      return;
                    }

                    showMsg(context, "Nộp bài test thành công", true);
                    context.goNamed("test_result");
                  } catch (e) {
                    if (!context.mounted) return;
                    showMsg(context, e.toString(), false);
                  }
                },
                child: const Text(
                  'Nộp bài',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,

                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          testProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: testProvider.testDetails.data!.length,
                  itemBuilder: (context, index) {
                    final testDetail = testProvider.testDetails.data![index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// QUESTION HEADER
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFDC5F5),
                                      Color(0xFFB388EB),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  'Câu ${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '/ ${testProvider.testDetails.data!.length}',
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          /// QUESTION CONTENT
                          Text(
                            testDetail.content,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// OPTIONS
                          ...testDetail.options.map((option) {
                            final isSelected =
                                selectedAnswers[testDetail.questionId] ==
                                option.answerId;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedAnswers[testDetail.questionId] =
                                      option.answerId;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xFFFDC5F5),
                                            Color(0xFFB388EB),
                                          ],
                                        )
                                      : null,
                                  color: isSelected ? null : softGrey,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.transparent
                                        : Colors.grey.shade200,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: primary.withOpacity(0.3),
                                            blurRadius: 12,
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Row(
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey,
                                          width: 2,
                                        ),
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.transparent,
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check,
                                              size: 16,
                                              color: primary,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        option.content,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
