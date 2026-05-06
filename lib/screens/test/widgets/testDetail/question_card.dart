import 'package:couple_mood_mobile/models/test/test_detail.dart';
import 'package:couple_mood_mobile/screens/test/widgets/testDetail/option_item.dart';
import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final int index;
  final int total;
  final TestDetail question;
  final String? selectedAnswer;
  final Function(String) onSelect;

  const QuestionCard({
    super.key,
    required this.index,
    required this.total,
    required this.question,
    required this.selectedAnswer,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
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
          /// HEADER
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFB388EB),
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
              Text('/ $total',
                  style: const TextStyle(color: Colors.black54)),
            ],
          ),

          const SizedBox(height: 14),

          /// CONTENT
          Text(
            question.content,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 16),

          /// OPTIONS
          ...question.options.map<Widget>((option) {
            return OptionItem(
              content: option.content,
              answerId: option.answerId,
              isSelected: selectedAnswer == option.answerId,
              onTap: () => onSelect(option.answerId),
            );
          }),
        ],
      ),
    );
  }
}