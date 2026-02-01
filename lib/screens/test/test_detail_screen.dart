import 'package:couple_mood_mobile/models/test/test_submit.dart';
import 'package:couple_mood_mobile/providers/test_provider.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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

    for (final question in context.read<TestProvider>().testDetails) {
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
        title: const Text('Chi tiết bài test'),
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            onPressed: () async {
              final provider = context.read<TestProvider>();

              TestSubmit answers = TestSubmit(
                action: "SAVE_PROGRESS",
                currentQuestionIndex: 0,
                answers: buildAnswerPayload(),
              );
              try {
                final GoRouterState state = GoRouterState.of(context);
                final Map<String, dynamic> extra =
                    state.extra as Map<String, dynamic>;
                final testId = extra['testId'];
                await provider.submitTestAnswers(testId, answers);
                if (!context.mounted) return;
                showMsg(context, "Đã lưu tiến trình", true);
                context.pop();
              } catch (e) {
                if (!context.mounted) return;
                showMsg(context, "Lỗi khi lưu tiến trình", false);
              }
            },
            label: const Text('Lưu tiến trình'),
          ),
          const SizedBox(width: 16),
          FloatingActionButton.extended(
            onPressed: () async {
              final provider = context.read<TestProvider>();
              TestSubmit answers = TestSubmit(
                action: "SUBMIT",
                currentQuestionIndex: 0,
                answers: buildAnswerPayload(),
              );
              try {
                final GoRouterState state = GoRouterState.of(context);
                final Map<String, dynamic> extra =
                    state.extra as Map<String, dynamic>;
                final testId = extra['testId'];
                await provider.submitTestAnswers(testId, answers);
                if (!context.mounted) return;
                showMsg(context, "Nộp bài test thành công", true);
              } catch (e) {
                if (!context.mounted) return;
                showMsg(context, "Bạn chưa hoàn thành bài test", false);
              }
            },
            label: const Text('Nộp bài'),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
        child: testProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  ...testProvider.testDetails.map((testDetail) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          testDetail.content,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...testDetail.options.map((option) {
                          return RadioListTile<String>(
                            title: Text(option.content),
                            value: option.answerId,
                            groupValue: selectedAnswers[testDetail.questionId],
                            onChanged: (String? value) {
                              setState(() {
                                selectedAnswers[testDetail.questionId] = value;
                              });
                            },
                          );
                        }),
                        const SizedBox(height: 20),
                      ],
                    );
                  }),
                ],
              ),
      ),
    );
  }
}
