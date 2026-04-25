import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:couple_mood_mobile/models/coupleInvitation/member_response.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';

void showInviteDialog({
  required BuildContext context,
  required MemberResponse user,
  required void Function(String message) onSend,
}) {
  final TextEditingController messageController = TextEditingController();
  messageController.text =
      "Xin chào ${user.fullName}, cho mình làm quen nhé! 💕";

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            gradient: LinearGradient(
              colors: [
                Color(0xFFFDC5F5),
                Color(0xFFB388EB),
                Color(0xFF72DDF7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// handle bar
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                /// avatar
                if (user.avatarUrl != null)
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(user.avatarUrl!),
                  )
                else
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white24,
                  ),

                const SizedBox(height: 12),

                /// title
                Text(
                  "Gửi lời mời đến ${user.fullName}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                /// input
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: messageController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Nhập lời nhắn ngọt ngào 💌",
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// button
                GestureDetector(
                  onTap: () async {
                    final message = messageController.text.trim();
                    if (message.isEmpty) {
                      context.pop();
                      showMsg(context, "Vui lòng nhập lời nhắn", false);
                      return;
                    }
                    onSend(message);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8093F1), Color(0xFFB388EB)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "Gửi lời mời 💖",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    },
  );
}