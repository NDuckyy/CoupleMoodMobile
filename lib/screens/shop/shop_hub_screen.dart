import 'package:couple_mood_mobile/providers/couple_provider.dart';
import 'package:couple_mood_mobile/providers/user/user_provider.dart';
import 'package:couple_mood_mobile/providers/shop/shop_provider.dart';
import 'package:couple_mood_mobile/widgets/shop/point_shop_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../widgets/shop/shop_tab.dart';
import '../../widgets/shop/inventory_tab.dart';

class ShopHubScreen extends StatefulWidget {
  final int initialTab;

  const ShopHubScreen({super.key, this.initialTab = 0});

  @override
  State<ShopHubScreen> createState() => _ShopHubScreenState();
}

class _ShopHubScreenState extends State<ShopHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );

    /// load lần đầu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final shopProvider = context.read<ShopProvider>();
      final userProvider = context.read<UserProvider>();

      // Luôn fetch User để cập nhật balance + couplePoints
      userProvider.fetchMe();

      shopProvider.fetchInitial();
      shopProvider.fetchInventory();
    });

    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;

    final provider = context.read<ShopProvider>();
    final userProvider = context.read<UserProvider>();

    if (_tabController.index == 0) {
      userProvider.fetchMe();
      provider.fetchInitial(); // tab shop
    } else {
      provider.fetchInventory(); // tab inventory
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange); // 👈 QUAN TRỌNG
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cửa hàng"),
        actions: [
          Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              final points = userProvider.user?.couplePoints ?? 0;

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: PointShopCard(
                  points: points,
                  onTap: () {
                    context.pushNamed('challenge');
                  },
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Cửa hàng"),
            Tab(text: "Tủ đồ"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [ShopTab(), InventoryTab()],
      ),
    );
  }
}
