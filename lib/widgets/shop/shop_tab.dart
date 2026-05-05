import 'package:couple_mood_mobile/models/venue/member_accessory.dart';
import 'package:couple_mood_mobile/providers/couple_provider.dart';
import 'package:couple_mood_mobile/providers/shop/shop_provider.dart';
import 'package:couple_mood_mobile/providers/user/user_provider.dart';
import 'package:couple_mood_mobile/widgets/shop/shop_search_filter.dart';
import 'package:couple_mood_mobile/widgets/shop/user_preview.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:couple_mood_mobile/widgets/shop/shop_accessory_card.dart';

class ShopTab extends StatefulWidget {
  const ShopTab({super.key});

  @override
  State<ShopTab> createState() => _ShopTabState();
}

class _ShopTabState extends State<ShopTab> {
  MemberAccessory? previewFrame;
  MemberAccessory? previewBadge;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<UserProvider>().fetchMe();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final shopProvider = context.watch<ShopProvider>();

    final user = userProvider.user;
    final items = shopProvider.items;

    if (shopProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        /// ===== SEARCH + FILTER =====
        const ShopSearchFilter(isInventory: false),
        const SizedBox(height: 16),

        /// ===== PREVIEW USER =====
        if (user != null) ...[
          Builder(
            builder: (_) {
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

              return UserPreview(user: user, frame: frame, badge: badge);
            },
          ),
        ],

        const SizedBox(height: 24),

        /// ===== LIST ITEM =====
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Center(
              child: Text(
                (shopProvider.shopKeyword.isNotEmpty ||
                        shopProvider.shopType != null)
                    ? "Không tìm thấy vật phẩm phù hợp"
                    : "Hiện chưa có vật phẩm nào",
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          ...items.map((item) {
            final isPreviewing =
                (item.type == "FRAME" &&
                    previewFrame?.accessoryId == item.accessoryId) ||
                (item.type == "BADGE" &&
                    previewBadge?.accessoryId == item.accessoryId);

            return ShopAccessoryCard(
              item: item,
              isPreviewing: isPreviewing,

              onTryToggle: () {
                setState(() {
                  if (item.type == "FRAME") {
                    previewFrame = isPreviewing ? null : item;
                  } else if (item.type == "BADGE") {
                    previewBadge = isPreviewing ? null : item;
                  }
                });
              },

              onPurchase: () async {
                try {
                  final shopProvider = context.read<ShopProvider>();

                  await shopProvider.purchase(item.accessoryId);

                  ///  reload inventory để có memberAccessoryId
                  await shopProvider.fetchInventory();

                  ///  tìm lại item trong inventory
                  final purchasedItem = shopProvider.inventoryItems.firstWhere(
                    (e) => e.accessoryId == item.accessoryId,
                  );

                  await shopProvider.equip(purchasedItem);

                  await context.read<UserProvider>().fetchMe();

                  showMsg(context, "Mua và trang bị thành công", true);
                } catch (e) {
                  showMsg(context, e.toString(), false);
                }
              },

              onEquipToggle: () async {
                final provider = context.read<ShopProvider>();

                /// luôn lấy item chuẩn từ inventory
                final invItem = provider.inventoryItems.firstWhere(
                  (e) => e.accessoryId == item.accessoryId,
                );

                if (invItem.isEquipped == true) {
                  await provider.unequip(invItem);
                } else {
                  await provider.equip(invItem);
                }

                await context.read<UserProvider>().fetchMe();
              },
            );
          }).toList(),
      ],
    );
  }
}
