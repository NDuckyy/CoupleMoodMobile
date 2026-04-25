import 'package:flutter/material.dart';

class SwipeHint extends StatefulWidget {
  const SwipeHint({super.key});

  @override
  State<SwipeHint> createState() => _SwipeHintState();
}

class _SwipeHintState extends State<SwipeHint>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.4,
      upperBound: 1,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose(); // ✅ tránh memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Row(
              children: [
                Icon(Icons.arrow_back, size: 20, color: Colors.red),
                Text(
                  "Vuốt trái để bỏ qua",
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ),
                SizedBox(width: 4),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 4),
                Text(
                  "Vuốt phải để mời",
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
                Icon(Icons.arrow_forward, size: 20, color: Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
