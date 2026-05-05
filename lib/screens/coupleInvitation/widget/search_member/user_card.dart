import 'package:couple_mood_mobile/models/coupleInvitation/member_response.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/dialog/invite_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserCard extends StatelessWidget {
  final void Function(String message) onSend;
  final MemberResponse user;

  const UserCard({super.key, required this.onSend, required this.user});

  Color getStatusColor() {
    switch (user.relationshipStatus) {
      case "SINGLE":
        return Colors.green;
      case "IN_RELATIONSHIP":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String getStatusText() {
    switch (user.relationshipStatus) {
      case "SINGLE":
        return "Độc thân";
      case "IN_RELATIONSHIP":
        return "Đã có đôi";
      default:
        return "Phức tạp";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          "member_profile_match",
          extra: {'userId': user.userId},
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            ///  BACKGROUND IMAGE
            Positioned.fill(
              child: Container(
                color: Colors.grey[300],
                child: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                    ? Image.network(
                        user.avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.person, size: 80),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;

                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      )
                    : const Center(child: Icon(Icons.person, size: 80)),
              ),
            ),

            /// 🔥 DARK GRADIENT (CHO TEXT RÕ)
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black54,
                      Colors.black87,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            /// 🔥 INFO BOTTOM
            Positioned(
              left: 16,
              right: 16,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// NAME
                  Text(
                    "${user.fullName}${user.age != null && user.age! > 0 ? ", ${user.age}" : ""}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 6),

                  if (user.jobTitle != null && user.jobTitle!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      user.jobTitle!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],

                  if (user.city != null && user.city!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      user.city!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],

                  if (user.personalityResultCode != null &&
                      user.personalityResultCode!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      "Tính cách: ${user.personalityResultCode}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),

                  /// STATUS
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 10,
                  //     vertical: 4,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: getStatusColor().withOpacity(0.9),
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   child: Text(
                  //     getStatusText(),
                  //     style: const TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 12,
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //   ),
                  // ),

                  // const SizedBox(height: 10),

                  /// BIO
                  Text(
                    user.bio?.isNotEmpty == true
                        ? user.bio!
                        : "Chưa có giới thiệu",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),

                  const SizedBox(height: 14),

                  /// BUTTON
                  if (user.canSendInvitation)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          showInviteDialog(
                            context: context,
                            user: user,
                            onSend: onSend,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB388EB),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Gửi lời mời 💖",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text(
                        "Đã gửi lời mời",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
