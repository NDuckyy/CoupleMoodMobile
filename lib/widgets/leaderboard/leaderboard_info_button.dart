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
                  "Điểm trên bảng xếp hạng phản ánh mức độ yêu thích và tương tác mà cộng đồng dành cho bạn.",
                  style: TextStyle(fontSize: 14, height: 1.5),
                ),

                const SizedBox(height: 12),

                const Text(
                  "💖 Mỗi lượt thích vào bài viết hoặc review của bạn đều giúp tăng điểm.\n\n"
                  "✨ Nội dung càng thú vị, chân thật và cảm xúc thì càng dễ nhận được nhiều lượt tương tác.\n\n"
                  "🏆 Các cặp đôi có tổng điểm cao nhất trong tháng sẽ dẫn đầu bảng xếp hạng.",
                  style: TextStyle(fontSize: 14, height: 1.5),
                ),

                const SizedBox(height: 12),

                const Text(
                  "💡 Gợi ý: Hãy chia sẻ những khoảnh khắc đáng nhớ, review địa điểm hoặc câu chuyện của riêng bạn để thu hút nhiều lượt thích hơn!",
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
