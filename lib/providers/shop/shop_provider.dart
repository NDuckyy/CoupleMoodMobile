import 'package:couple_mood_mobile/models/venue/member_accessory.dart';
import 'package:couple_mood_mobile/services/shop/shop_service.dart';
import 'package:flutter/material.dart';

class ShopProvider extends ChangeNotifier {
  List<MemberAccessory> items = [];

  bool isLoading = false;
  bool isLoadingMore = false;

  int page = 1;
  int totalPages = 1;

  /// INIT
  Future<void> fetchInitial() async {
    page = 1;
    totalPages = 1;
    items.clear();

    isLoading = true;
    notifyListeners();

    try {
      /// 1. gọi shop
      final shopRes = await MemberAccessoryService.getShop(page: page);

      /// 2. gọi inventory
      final invRes = await MemberAccessoryService.getMyAccessories(
        page: 1,
        pageSize: 100,
      );

      if (shopRes.code == 200 && shopRes.data != null) {
        final shopItems = shopRes.data!.items;

        final inventory = invRes.data?.items ?? [];

        /// map inventory theo accessoryId
        final map = {for (var e in inventory) e.accessoryId: e};

        /// merge
        items = shopItems.map((shopItem) {
          final inv = map[shopItem.accessoryId];

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

            ///  merge state
            isOwnedByMe: inv != null,
            isEquipped: inv?.isEquipped ?? false,
          );
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

  /// LOAD MORE
  Future<void> loadMore() async {
    if (isLoadingMore || isLoading) return;
    if (page >= totalPages) return;

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
        final map = {for (var e in inventory) e.accessoryId: e};

        final newItems = shopRes.data!.items.map((shopItem) {
          final inv = map[shopItem.accessoryId];

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
            isEquipped: inv?.isEquipped ?? false,
          );
        }).toList();

        page = nextPage;
        items.addAll(newItems);
        totalPages = shopRes.data!.totalPages;
      }
    } catch (e) {
      debugPrint("loadMore error: $e");
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  /// REFRESH
  Future<void> refresh() async {
    await fetchInitial();
  }

  Future<void> purchase(int accessoryId) async {
    try {
      await MemberAccessoryService.purchase(accessoryId);

      /// reload shop + user
      await fetchInitial();
    } catch (e) {
      debugPrint("purchase error: $e");
    }
  }

  Future<void> equip(MemberAccessory item) async {
    try {
      /// tìm cái đang equip cùng type
      final current = items.firstWhere(
        (e) => e.type == item.type && e.isEquipped == true,
        orElse: () => MemberAccessory.empty(),
      );

      /// nếu có cái khác đang equip → tháo nó
      if (current.memberAccessoryId != null &&
          current.memberAccessoryId != item.memberAccessoryId) {
        await MemberAccessoryService.unequip(current.memberAccessoryId!);
      }

      /// equip cái mới
      await MemberAccessoryService.equip(item.memberAccessoryId!);

      await fetchInitial();
    } catch (e) {
      debugPrint("equip error: $e");
    }
  }

  Future<void> unequip(MemberAccessory item) async {
    try {
      await MemberAccessoryService.unequip(item.memberAccessoryId!);
      await fetchInitial();
    } catch (e) {
      debugPrint("unequip error: $e");
    }
  }
}
