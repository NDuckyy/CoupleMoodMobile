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
      final res = await MemberAccessoryService.getShop(page: page);

      if (res.code == 200 && res.data != null) {
        items = res.data!.items;
        totalPages = res.data!.totalPages;
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

      final res = await MemberAccessoryService.getShop(page: nextPage);

      if (res.code == 200 && res.data != null) {
        page = nextPage;

        items.addAll(res.data!.items);

        totalPages = res.data!.totalPages;
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
}
