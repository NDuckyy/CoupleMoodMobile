import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_mood_mobile/models/venue/member_accessory.dart';
import 'package:flutter/material.dart';

class UserPreview extends StatelessWidget {
  final dynamic user;
  final MemberAccessory frame;
  final MemberAccessory badge;

  const UserPreview({
    super.key,
    required this.user,
    required this.frame,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    const size = 80.0;

    final hasAvatar =
        user.avatarUrl != null && user.avatarUrl!.trim().isNotEmpty;

    return Column(
      children: [
        /// ===== AVATAR + FRAME =====
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// AVATAR
              CircleAvatar(
                radius: size / 2,
                backgroundColor: Colors.grey[200],
                backgroundImage: hasAvatar
                    ? CachedNetworkImageProvider(user.avatarUrl!)
                    : null,
                child: !hasAvatar ? const Icon(Icons.person, size: 32) : null,
              ),

              /// FRAME
              if (frame.thumbnailUrl != null && frame.thumbnailUrl!.isNotEmpty)
                Transform.scale(
                  scale: 1.3,
                  child: CachedNetworkImage(
                    imageUrl: frame.thumbnailUrl!,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    memCacheWidth: 200,
                    placeholder: (_, __) => const SizedBox.shrink(),
                    errorWidget: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        /// ===== NAME + BADGE =====
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user.fullName ?? '',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),

            if (badge.thumbnailUrl != null &&
                badge.thumbnailUrl!.isNotEmpty) ...[
              const SizedBox(width: 6),
              CachedNetworkImage(
                imageUrl: badge.thumbnailUrl!,
                width: 18,
                height: 18,
                fit: BoxFit.cover,
                memCacheWidth: 60,
                placeholder: (_, __) => const SizedBox(width: 18, height: 18),
                errorWidget: (_, __, ___) =>
                    const Icon(Icons.error, size: 18, color: Colors.grey),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
