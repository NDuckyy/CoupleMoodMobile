import 'package:couple_mood_mobile/models/venue/member_accessory.dart';
import 'package:couple_mood_mobile/providers/shop/shop_provider.dart';
import 'package:couple_mood_mobile/providers/user/user_provider.dart';
import 'package:couple_mood_mobile/widgets/shop/inventory_accessory_card.dart';
import 'package:couple_mood_mobile/widgets/shop/shop_search_filter.dart';
import 'package:couple_mood_mobile/widgets/shop/user_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventoryTab extends StatefulWidget {
  const InventoryTab({super.key});

  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab> {
  MemberAccessory? previewFrame;
  MemberAccessory? previewBadge;

  @override
  void initState() {
    super.initState();

    /// Không fetch ở đây (Hub lo rồi)
    Future.microtask(() {
      final userProvider = context.read<UserProvider>();
      if (userProvider.user == null) {
        userProvider.fetchMe();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final shopProvider = context.watch<ShopProvider>();

    final user = userProvider.user;
    final items = shopProvider.inventoryItems;

    if (shopProvider.isInventoryLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        /// ===== SEARCH + FILTER =====
        const ShopSearchFilter(isInventory: true),
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
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(child: Text("Bạn chưa có vật phẩm nào")),
          )
        else
          ...items.map((item) {
            final isPreviewing =
                (item.type == "FRAME" &&
                    previewFrame?.accessoryId == item.accessoryId) ||
                (item.type == "BADGE" &&
                    previewBadge?.accessoryId == item.accessoryId);

            return InventoryAccessoryCard(
              item: item,
              isPreviewing: isPreviewing,

              ///  vẫn cho preview thử
              onTryToggle: () {
                setState(() {
                  if (item.type == "FRAME") {
                    previewFrame = isPreviewing ? null : item;
                  } else if (item.type == "BADGE") {
                    previewBadge = isPreviewing ? null : item;
                  }
                });
              },

              /// ✅ vẫn equip / unequip
              onEquipToggle: () async {
                final provider = context.read<ShopProvider>();

                if (item.isEquipped == true) {
                  await provider.unequip(item);
                } else {
                  await provider.equip(item);
                }

                await context.read<UserProvider>().fetchMe();
              },
            );
          }).toList(),
      ],
    );
  }
}
