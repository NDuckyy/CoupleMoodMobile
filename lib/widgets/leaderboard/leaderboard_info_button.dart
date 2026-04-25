import 'package:flutter/material.dart';

class LeaderboardInfoButton extends StatelessWidget {
  const LeaderboardInfoButton({super.key});

  void _showInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                Row(
                  children: const [
                    Icon(Icons.emoji_events, color: Colors.pink),
                    SizedBox(width: 8),
                    Text(
                      "Cách tính điểm",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                /// CONTENT
                const Text(
                  "Điểm trên bảng xếp hạng được tính dựa trên số thử thách mà bạn (và người ấy) hoàn thành.",
                  style: TextStyle(fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 12),
                const Text(
                  "🏆 Mỗi thử thách hoàn thành sẽ mang lại một lượng điểm nhất định.\n\n"
                  "🛒 Điểm tích lũy có thể dùng để mua phụ kiện trang trí trong Shop.\n\n"
                  "🎁 Cặp đôi đứng Top 1 bảng xếp hạng vào cuối tháng sẽ nhận được khung avatar đặc biệt.",
                  style: TextStyle(fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 12),
                const Text(
                  "💡 Gợi ý: Hãy cùng nhau hoàn thành nhiều thử thách thú vị nhất có thể để tích điểm nhanh và lên top bảng xếp hạng!",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),

                /// BUTTON
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Đã hiểu",
                      style: TextStyle(color: Colors.pink),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.help_outline),
      onPressed: () => _showInfo(context),
    );
  }
}
