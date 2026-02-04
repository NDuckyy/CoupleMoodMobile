import 'package:couple_mood_mobile/models/test/test_result.dart';
import 'package:couple_mood_mobile/providers/test_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TestResultScreen extends StatelessWidget {
  const TestResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final testProvider = context.watch<TestProvider>();
    final testResult = testProvider.testResult;
    debugPrint('Rendering TestResultScreen with testResult: ${testResult?.result.mbtiCode}');

    return Scaffold(
      appBar: AppBar(title: const Text('Kết quả bài test'), centerTitle: true),
      body: testResult == null
          ? const Center(child: Text('Không có kết quả để hiển thị.'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _HeaderCard(
                  mbtiCode: testResult.result.mbtiCode,
                  name: (testResult.result.name),
                ),
                const SizedBox(height: 14),

                if (testResult.result.breakdown?.percent != null) ...[
                  _SectionTitle(title: 'Tổng quan tính cách'),
                  const SizedBox(height: 10),
                  _BreakdownCard(percent: testResult.result.breakdown!.percent),
                  const SizedBox(height: 14),
                ],

                _SectionTitle(title: 'Điểm nổi bật'),
                const SizedBox(height: 10),
                _DescriptionCard(items: testResult.result.description),
                const SizedBox(height: 18),

                _ActionsRow(
                  onHome: () => context.goNamed('home'), // đổi đúng route name
                  onBack: () => context.pop(),
                ),
              ],
            ),
    );
  }
}

/// =====================
/// Header Card
/// =====================
class _HeaderCard extends StatelessWidget {
  final String mbtiCode;
  final String name;

  const _HeaderCard({required this.mbtiCode, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE1E1), Color(0xFFFFF4FB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            height: 62,
            width: 62,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.psychology_alt_rounded, size: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    _MbtiBadge(text: mbtiCode),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Đây là kết quả tổng hợp dựa trên câu trả lời của bạn.',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MbtiBadge extends StatelessWidget {
  final String text;
  const _MbtiBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// =====================
/// Section Title
/// =====================
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
    );
  }
}

/// =====================
/// Description Card
/// =====================
class _DescriptionCard extends StatelessWidget {
  final List<String> items;
  const _DescriptionCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFFF8F8F8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: items
              .map(
                (t) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(t, style: const TextStyle(fontSize: 15)),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

/// =====================
/// Breakdown Card
/// Expect: percent map keys like:
/// E_percent, I_percent, S_percent, N_percent, T_percent, F_percent, J_percent, P_percent
/// =====================
class _BreakdownCard extends StatelessWidget {
  final TestPercent percent;

  const _BreakdownCard({required this.percent});
  @override
  Widget build(BuildContext context) {
    final e = percent.ePercent;
    final i = percent.iPercent;
    final s = percent.sPercent;
    final n = percent.nPercent;
    final t = percent.tPercent;
    final f = percent.fPercent;
    final j = percent.jPercent;
    final p = percent.pPercent;

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            _TraitBar(left: 'E', right: 'I', leftValue: e, rightValue: i),
            const SizedBox(height: 12),
            _TraitBar(left: 'S', right: 'N', leftValue: s, rightValue: n),
            const SizedBox(height: 12),
            _TraitBar(left: 'T', right: 'F', leftValue: t, rightValue: f),
            const SizedBox(height: 12),
            _TraitBar(left: 'J', right: 'P', leftValue: j, rightValue: p),
          ],
        ),
      ),
    );
  }
}

class _TraitBar extends StatelessWidget {
  final String left;
  final String right;
  final double leftValue;
  final double rightValue;

  const _TraitBar({
    required this.left,
    required this.right,
    required this.leftValue,
    required this.rightValue,
  });

  @override
  Widget build(BuildContext context) {
    final total = leftValue + rightValue;
    final leftRatio = total == 0 ? 0.5 : (leftValue / total).clamp(0.0, 1.0);
    final rightRatio = 1 - leftRatio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('$left ${leftValue.toStringAsFixed(1)}%'),
            const Spacer(),
            Text('${rightValue.toStringAsFixed(1)}% $right'),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 10,
            child: Row(
              children: [
                Expanded(
                  flex: (leftRatio * 1000).round(),
                  child: Container(color: Colors.black87),
                ),
                Expanded(
                  flex: (rightRatio * 1000).round(),
                  child: Container(color: Colors.black12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// =====================
/// Action buttons
/// =====================
class _ActionsRow extends StatelessWidget {
  final VoidCallback onHome;
  final VoidCallback onBack;

  const _ActionsRow({required this.onHome, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onHome,
            icon: const Icon(Icons.home),
            label: const Text('Về trang chủ'),
          ),
        ),
      ],
    );
  }
}
