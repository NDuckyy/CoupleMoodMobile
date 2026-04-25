import 'package:couple_mood_mobile/models/test/test_result.dart';
import 'package:flutter/material.dart';

class TestBreakdownCard extends StatelessWidget {
  final TestPercent percent;

  const TestBreakdownCard({required this.percent, super.key});
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15),
        ],
      ),
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
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF8093F1), Color(0xFF72DDF7)],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: (rightRatio * 1000).round(),
                  child: Container(color: Colors.grey.shade200),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
