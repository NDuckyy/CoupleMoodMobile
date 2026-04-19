import 'package:flutter/material.dart';

class MatchSwitch extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;

  const MatchSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final text = value ? "Phù hợp" : "Không phù hợp";
    final color = value ? Colors.green : Colors.redAccent;
    final icon = value ? Icons.check_circle : Icons.cancel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Trải nghiệm có phù hợp không?",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),

        const SizedBox(height: 4),

        const Text(
          "Đánh giá tổng thể cảm nhận của bạn",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 6),
                Text(
                  text,
                  style: TextStyle(fontWeight: FontWeight.w600, color: color),
                ),
              ],
            ),

            Switch(
              value: value,
              activeColor: const Color(0xFFFF4E9E),
              onChanged: onChanged,
            ),
          ],
        ),
      ],
    );
  }
}
