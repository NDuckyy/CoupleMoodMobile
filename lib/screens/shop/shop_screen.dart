import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_mood_mobile/models/venue/member_accessory.dart';
import 'package:couple_mood_mobile/providers/shop/shop_provider.dart';
import 'package:couple_mood_mobile/providers/user/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  MemberAccessory? previewFrame;
  MemberAccessory? previewBadge;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final userProvider = context.read<UserProvider>();
      if (userProvider.user == null) {
        userProvider.fetchMe();
      }

      context.read<ShopProvider>().fetchInitial();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final shopProvider = context.watch<ShopProvider>();

    final user = userProvider.user;
    final items = shopProvider.items;

    return Scaffold(
      appBar: AppBar(title: const Text("Cửa hàng")),
      body: shopProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (user != null) _buildUserPreview(user),
                const SizedBox(height: 20),
                ...items.map((item) => _buildItem(item)).toList(),
              ],
            ),
    );
  }

  /// ================= PREVIEW =================
  Widget _buildUserPreview(dynamic user) {
    // giữ dynamic để tránh lỗi type
    final equipped = user.memberProfile?.equippedAccessories ?? [];

    final frame =
        previewFrame ??
        equipped.firstWhere(
          (e) => e.type == "FRAME",
          orElse: () => MemberAccessory.empty(),
        );

    final badge =
        previewBadge ??
        equipped.firstWhere(
          (e) => e.type == "BADGE",
          orElse: () => MemberAccessory.empty(),
        );

    final size = 80.0;

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
                backgroundImage: user.avatarUrl != null
                    ? CachedNetworkImageProvider(user.avatarUrl!)
                    : null,
                child: user.avatarUrl == null
                    ? const Icon(Icons.person, size: 32)
                    : null,
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
                    memCacheWidth: 200, // tối ưu RAM
                    placeholder: (context, url) => const SizedBox.shrink(),
                    errorWidget: (context, url, error) =>
                        const SizedBox.shrink(),
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

  /// ================= ITEM =================
  Widget _buildItem(MemberAccessory item) {
    final isPreviewing =
        (item.type == "FRAME" &&
            previewFrame?.accessoryId == item.accessoryId) ||
        (item.type == "BADGE" && previewBadge?.accessoryId == item.accessoryId);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: item.thumbnailUrl ?? '',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              memCacheWidth: 120, // tối ưu RAM cho thumbnail
              placeholder: (context, url) => Container(
                width: 60,
                height: 60,
                color: Colors.grey[200],
                child: const Icon(Icons.image, color: Colors.grey),
              ),
              errorWidget: (context, url, error) => Container(
                width: 60,
                height: 60,
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${item.pricePoint} points",
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),

          /// BUTTON GROUP
          Column(
            children: [
              if (!(item.isOwnedByMe ?? false)) ...[
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      if (item.type == "FRAME") {
                        previewFrame = isPreviewing ? null : item;
                      } else if (item.type == "BADGE") {
                        previewBadge = isPreviewing ? null : item;
                      }
                    });
                  },
                  child: Text(isPreviewing ? "Bỏ thử" : "Thử"),
                ),
                const SizedBox(height: 6),
                ElevatedButton(
                  onPressed: () async {
                    await context.read<ShopProvider>().purchase(
                      item.accessoryId,
                    );
                    await context.read<UserProvider>().fetchMe();
                  },
                  child: const Text("Đổi"),
                ),
              ] else ...[
                ElevatedButton(
                  onPressed: () async {
                    final provider = context.read<ShopProvider>();
                    if (item.isEquipped == true) {
                      await provider.unequip(item);
                    } else {
                      await provider.equip(item);
                    }
                    await context.read<UserProvider>().fetchMe();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: item.isEquipped == true
                        ? Colors.grey
                        : Colors.blue,
                  ),
                  child: Text(item.isEquipped == true ? "Tháo" : "Trang bị"),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
