import 'package:couple_mood_mobile/models/venue/member_accessory.dart';
import 'package:couple_mood_mobile/services/shop/shop_service.dart';
import 'package:flutter/material.dart';

class ShopProvider extends ChangeNotifier {
  List<MemberAccessory> items = [];
  List<MemberAccessory> inventoryItems = [];

  bool isLoading = false;
  bool isLoadingMore = false;

  bool isInventoryLoading = false;

  int page = 1;
  int totalPages = 1;

  int inventoryPage = 1;
  int inventoryTotalPages = 1;

  String? shopType;
  String? inventoryType;

  String shopKeyword = '';
  String inventoryKeyword = '';

  /// ==================== INIT & LOAD ====================
  Future<void> fetchInitial() async {
    page = 1;
    items.clear();
    isLoading = true;
    notifyListeners();

    try {
      final shopRes = await MemberAccessoryService.getShop(
        page: page,
        keyword: shopKeyword.isNotEmpty ? shopKeyword : null,
        type: shopType,
      );

      final invRes = await MemberAccessoryService.getMyAccessories(
        page: 1,
        pageSize: 100,
      );

      if (shopRes.code == 200 && shopRes.data != null) {
        final shopItems = shopRes.data!.items;
        final inventory = invRes.data?.items ?? [];
        final invMap = {for (var e in inventory) e.accessoryId: e};

        items = shopItems.map((shopItem) {
          final inv = invMap[shopItem.accessoryId];
          return _mergeAccessory(shopItem, inv);
        }).toList();

        totalPages = shopRes.data!.totalPages;
      }
    } catch (e) {
      debugPrint("fetchInitial error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore || isLoading || page >= totalPages) return;

    isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = page + 1;
      final shopRes = await MemberAccessoryService.getShop(page: nextPage);
      final invRes = await MemberAccessoryService.getMyAccessories(
        page: 1,
        pageSize: 100,
      );

      if (shopRes.code == 200 && shopRes.data != null) {
        final inventory = invRes.data?.items ?? [];
        final invMap = {for (var e in inventory) e.accessoryId: e};

        final newItems = shopRes.data!.items.map((shopItem) {
          final inv = invMap[shopItem.accessoryId];
          return _mergeAccessory(shopItem, inv);
        }).toList();

        items.addAll(newItems);
        page = nextPage;
        totalPages = shopRes.data!.totalPages;
      }
    } catch (e) {
      debugPrint("loadMore error: $e");
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  MemberAccessory _mergeAccessory(dynamic shopItem, dynamic inv) {
    return MemberAccessory(
      memberAccessoryId: inv?.memberAccessoryId,
      accessoryId: shopItem.accessoryId,
      code: shopItem.code,
      name: shopItem.name,
      type: shopItem.type,
      thumbnailUrl: shopItem.thumbnailUrl,
      resourceUrl: shopItem.resourceUrl,
      pricePoint: shopItem.pricePoint,
      isLimited: shopItem.isLimited,
      totalQuantity: shopItem.totalQuantity,
      remainingQuantity: shopItem.remainingQuantity,
      status: shopItem.status,
      canPurchase: shopItem.canPurchase,
      isOwnedByMe: inv != null,
      isOwnedByPartner: inv?.isOwnedByPartner,
      isEquipped: inv?.isEquipped ?? false,
    );
  }

  /// ==================== ACTIONS ====================
  Future<void> purchase(int accessoryId) async {
    try {
      final res = await MemberAccessoryService.purchase(accessoryId);

      if (res.code != 200) {
        throw (res.message ?? "Đổi thất bại");
      }

      final index = items.indexWhere((e) => e.accessoryId == accessoryId);
      if (index != -1) {
        items[index] = items[index].copyWith(
          isOwnedByMe: true,
          isEquipped: false,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint("purchase error: $e");
      rethrow;
    }
  }

  Future<void> equip(MemberAccessory item) async {
    try {
      /// ===== SHOP LIST =====
      final currentEquippedIndex = items.indexWhere(
        (e) => e.type == item.type && e.isEquipped == true,
      );

      if (currentEquippedIndex != -1) {
        items[currentEquippedIndex] = items[currentEquippedIndex].copyWith(
          isEquipped: false,
        );
      }

      final targetIndex = items.indexWhere(
        (e) => e.accessoryId == item.accessoryId,
      );

      if (targetIndex != -1) {
        items[targetIndex] = items[targetIndex].copyWith(isEquipped: true);
      }

      /// ===== INVENTORY LIST (THÊM ĐOẠN NÀY) =====
      final currentInvIndex = inventoryItems.indexWhere(
        (e) => e.type == item.type && e.isEquipped == true,
      );

      if (currentInvIndex != -1) {
        inventoryItems[currentInvIndex] = inventoryItems[currentInvIndex]
            .copyWith(isEquipped: false);
      }

      final targetInvIndex = inventoryItems.indexWhere(
        (e) => e.accessoryId == item.accessoryId,
      );

      if (targetInvIndex != -1) {
        inventoryItems[targetInvIndex] = inventoryItems[targetInvIndex]
            .copyWith(isEquipped: true);
      }

      await MemberAccessoryService.equip(item.memberAccessoryId!);

      notifyListeners();
    } catch (e) {
      debugPrint("equip error: $e");
    }
  }

  Future<void> unequip(MemberAccessory item) async {
    try {
      /// shop list
      final index = items.indexWhere((e) => e.accessoryId == item.accessoryId);

      if (index != -1) {
        items[index] = items[index].copyWith(isEquipped: false);
      }

      /// inventory list (THÊM)
      final invIndex = inventoryItems.indexWhere(
        (e) => e.accessoryId == item.accessoryId,
      );

      if (invIndex != -1) {
        inventoryItems[invIndex] = inventoryItems[invIndex].copyWith(
          isEquipped: false,
        );
      }

      await MemberAccessoryService.unequip(item.memberAccessoryId!);

      notifyListeners();
    } catch (e) {
      debugPrint("unequip error: $e");
    }
  }

  Future<void> fetchInventory() async {
    inventoryPage = 1;
    inventoryItems.clear();
    isInventoryLoading = true;
    notifyListeners();

    try {
      final res = await MemberAccessoryService.getMyAccessories(
        page: inventoryPage,
        pageSize: 20,
        type: inventoryType,
        keyword: inventoryKeyword.isNotEmpty ? inventoryKeyword : null,
      );

      if (res.code == 200 && res.data != null) {
        inventoryItems = res.data!.items;
        inventoryTotalPages = res.data!.totalPages;
      }
    } catch (e) {
      debugPrint("fetchInventory error: $e");
    } finally {
      isInventoryLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreInventory() async {
    if (isInventoryLoading || inventoryPage >= inventoryTotalPages) return;

    try {
      final nextPage = inventoryPage + 1;

      final res = await MemberAccessoryService.getMyAccessories(
        page: inventoryPage,
        pageSize: 20,
        type: inventoryType,
        keyword: inventoryKeyword,
      );

      if (res.code == 200 && res.data != null) {
        inventoryItems.addAll(res.data!.items);
        inventoryPage = nextPage;
        inventoryTotalPages = res.data!.totalPages;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("loadMoreInventory error: $e");
    }
  }

  Future<void> refresh() async => await fetchInitial();

  void updateShopType(String? type) {
    shopType = type;
  }

  void updateInventoryType(String? type) {
    inventoryType = type;
  }
}
