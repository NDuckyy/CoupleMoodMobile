import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_mood_mobile/providers/user/user_provider.dart';
import 'package:couple_mood_mobile/utils/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePostBox extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onAvatarTap;

  const CreatePostBox({super.key, this.onTap, this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    // Lấy Frame
    final accessories = user?.memberProfile?.equippedAccessories ?? [];
    final frame = accessories.where((e) => e.type == "FRAME").firstOrNull;

    final firstName = getVietnameseFirstName(user?.fullName ?? '');

    // Kiểm tra avatar an toàn
    final avatarUrl = user?.avatarUrl;
    final hasValidAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.05)),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onAvatarTap,
            child: SizedBox(
              width: 52,
              height: 52,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 21, // nhỏ hơn một chút để nhường chỗ cho frame
                    backgroundColor: Colors.grey[200],
                    backgroundImage: hasValidAvatar
                        ? NetworkImage(avatarUrl!)
                        : null,
                    child: hasValidAvatar
                        ? null
                        : const Icon(Icons.person, color: Colors.grey),
                  ),

                  // Frame - Cách tiếp cận tương tự PostHeader nhưng điều chỉnh scale
                  if (frame?.thumbnailUrl?.isNotEmpty == true)
                    Transform.scale(
                      scale: 1.8, // thử giá trị này trước (tăng từ 1.2)
                      child: CachedNetworkImage(
                        imageUrl: frame!.thumbnailUrl!,
                        width: 52, // bằng với SizedBox ngoài
                        height: 52,
                        fit: BoxFit.contain, // thay vì cover → ít bị méo hơn
                        placeholder: (_, __) => const SizedBox.shrink(),
                        errorWidget: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey[200],
                ),
                child: Text(
                  firstName != null && firstName!.isNotEmpty
                      ? "$firstName ơi, bạn đang nghĩ gì?"
                      : "Bạn đang nghĩ gì?",
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
