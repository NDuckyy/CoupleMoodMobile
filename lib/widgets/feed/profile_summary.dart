import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_mood_mobile/providers/user/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileSummary extends StatelessWidget {
  const ProfileSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    if (user == null) {
      return const SizedBox();
    }

    final accessories = user.memberProfile?.equippedAccessories ?? [];
    final frame = accessories.where((e) => e.type == "FRAME").firstOrNull;
    final badge = accessories.where((e) => e.type == "BADGE").firstOrNull;

    const avatarSize = 48.0;

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: user.avatarUrl != null
                      ? NetworkImage(user.avatarUrl!)
                      : null,
                  child: user.avatarUrl == null
                      ? const Icon(Icons.person, size: 26)
                      : null,
                ),
                if (frame?.thumbnailUrl?.isNotEmpty == true)
                  Transform.scale(
                    scale: 1.3,
                    child: CachedNetworkImage(
                      imageUrl: frame!.thumbnailUrl!,
                      width: 56,
                      height: 56,
                      fit: BoxFit.contain,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.fullName ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    if (badge?.thumbnailUrl?.isNotEmpty == true) ...[
                      const SizedBox(width: 8),
                      CachedNetworkImage(
                        imageUrl: badge!.thumbnailUrl!,
                        width: 22,
                        height: 22,
                      ),
                    ],
                  ],
                ),
                const Text(
                  "View your posts",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
