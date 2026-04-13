import 'package:couple_mood_mobile/providers/test_provider.dart';
import 'package:couple_mood_mobile/screens/test/widgets/testResult/test_action_row.dart';
import 'package:couple_mood_mobile/screens/test/widgets/testResult/test_breakdown_card.dart';
import 'package:couple_mood_mobile/screens/test/widgets/testResult/test_description_card.dart';
import 'package:couple_mood_mobile/screens/test/widgets/testResult/test_header_card.dart';
import 'package:couple_mood_mobile/screens/test/widgets/testResult/test_section_title.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TestResultScreen extends StatelessWidget {
  const TestResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final testProvider = context.watch<TestProvider>();
    final testResult = testProvider.testResult;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Kết quả 💕',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,

      body: Stack(
        children: [
          testResult == null
              ? const Center(child: Text('Không có kết quả để hiển thị.'))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
                  children: [
                    TestHeaderCard(
                      mbtiCode: testResult.result.mbtiCode,
                      name: (testResult.result.name),
                    ),
                    const SizedBox(height: 14),

                    if (testResult.result.breakdown?.percent != null) ...[
                      TestSectionTitle(title: 'Tổng quan tính cách'),
                      const SizedBox(height: 10),
                      TestBreakdownCard(
                        percent: testResult.result.breakdown!.percent,
                      ),
                      const SizedBox(height: 14),
                    ],

                    TestSectionTitle(title: 'Điểm nổi bật'),
                    const SizedBox(height: 10),
                    TestDescriptionCard(items: testResult.result.description),
                    const SizedBox(height: 18),

                    TestActionsRow(
                      onHome: () =>
                          context.goNamed('home'),
                      onBack: () => context.pop(),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}