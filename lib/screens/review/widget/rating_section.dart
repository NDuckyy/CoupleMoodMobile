import 'package:flutter/material.dart';

class RatingSection extends StatelessWidget {
  final int rating;
  final Function(int) onChanged;

  const RatingSection({
    super.key,
    required this.rating,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Bạn đánh giá bao nhiêu sao?",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            return IconButton(
              onPressed: () => onChanged(starIndex),
              icon: Icon(
                Icons.star,
                size: 32,
                color: starIndex <= rating
                    ? const Color(0xFFB388EB)
                    : Colors.grey[300],
              ),
            );
          }),
        ),
      ],
    );
  }
}
