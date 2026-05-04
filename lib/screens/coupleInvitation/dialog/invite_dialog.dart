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
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// handle bar
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                /// avatar
                if (user.avatarUrl != null)
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(user.avatarUrl!),
                  )
                else
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Color(0xFFEDE7F6),
                  ),

                const SizedBox(height: 12),

                /// title
                Text(
                  "Gửi lời mời đến ${user.fullName}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 16),

                /// input
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: messageController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Nhập lời nhắn 💌",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(14),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// button
                GestureDetector(
                  onTap: () {
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
                      color: const Color(0xFFB388EB), // tím pastel
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: Text(
                        "Gửi lời mời 💖",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      );
    },
  );
}
