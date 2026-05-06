import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_mood_mobile/utils/time_utils.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final dynamic user;
  final dynamic subscription;
  final bool hasSub;
  final double opacity;

  final VoidCallback onEditProfile;
  final VoidCallback onViewSubscription;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.subscription,
    required this.hasSub,
    required this.opacity,
    required this.onEditProfile,
    required this.onViewSubscription,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 16),
        child: Column(
          children: [
            /// ================= TITLE =================
            const SizedBox(
              height: 44,
              child: Center(
                child: Text(
                  "Thông tin của tôi",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// ================= USER INFO =================
            Row(
              children: [
                /// AVATAR
                SizedBox(
                  width: 72,
                  height: 72,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: user?.avatarUrl != null
                            ? NetworkImage(user!.avatarUrl!)
                            : null,
                        child: user?.avatarUrl == null
                            ? const Icon(Icons.person, size: 32)
                            : null,
                      ),

                      /// FRAME ACCESSORY
                      if (user?.memberProfile?.equippedAccessories != null)
                        ...user!.memberProfile!.equippedAccessories!
                            .where((e) => e.type == "FRAME")
                            .take(1)
                            .map(
                              (frame) => Transform.scale(
                                scale: 1.3,
                                child: CachedNetworkImage(
                                  imageUrl: frame.thumbnailUrl ?? '',
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.contain,
                                  errorWidget: (_, __, ___) =>
                                      const SizedBox.shrink(),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                /// NAME + EMAIL + POINTS
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    user?.memberProfile?.fullName ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),

                                if (user?.memberProfile?.equippedAccessories !=
                                    null)
                                  ...user!.memberProfile!.equippedAccessories!
                                      .where((e) => e.type == "BADGE")
                                      .take(1)
                                      .map(
                                        (badge) => CachedNetworkImage(
                                          imageUrl: badge.thumbnailUrl ?? '',
                                          width: 22,
                                          height: 22,
                                        ),
                                      ),
                              ],
                            ),

                            const SizedBox(height: 4),

                            Text(
                              user?.email ?? '',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Row(
                              children: [
                                const Icon(
                                  Icons.monetization_on,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${user?.points ?? 0}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: onEditProfile,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// ================= SUBSCRIPTION =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasSub
                              ? (subscription?.packageName ?? "Thành viên")
                              : "Chưa có gói",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hasSub &&
                                  subscription?.startDate != null &&
                                  subscription?.endDate != null
                              ? "${formatDateTimeVN(subscription.startDate)} → ${formatDateTimeVN(subscription.endDate)}"
                              : "Nâng cấp để sử dụng đầy đủ tính năng",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),

                  InkWell(
                    onTap: onViewSubscription,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Xem chi tiết",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
