import 'package:couple_mood_mobile/models/voucher/voucher_item_model.dart';
import 'package:flutter/material.dart';
import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/paginated_response.dart';
import 'package:couple_mood_mobile/services/voucher/voucher_service.dart';

class VoucherProvider extends ChangeNotifier {
  ApiResponse<PaginatedResponse<VoucherItem>>? _response;

  bool isLoading = false;
  bool isLoadingMore = false;
  String? error;

  int _page = 1;
  final int _pageSize = 10;
  bool hasMore = true;

  List<VoucherItem> get vouchers => _response?.data?.items ?? [];

  /// INITIAL LOAD / REFRESH
  Future<void> fetchVouchers({bool refresh = false}) async {
    if (isLoading) return;

    if (refresh) {
      _page = 1;
      hasMore = true;
      _response = null;
    }

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final res = await VoucherService.getVouchers(
        page: _page,
        pageSize: _pageSize,
        sortBy: 'createdAt',
        orderBy: 'desc',
      );

      _response = res;
      hasMore = res.data?.hasNextPage ?? false;
      _page++;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// LOAD MORE (infinite scroll)
  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore) return;

    isLoadingMore = true;
    notifyListeners();

    try {
      final res = await VoucherService.getVouchers(
        page: _page,
        pageSize: _pageSize,
        sortBy: 'createdAt',
        orderBy: 'desc',
      );

      final newItems = res.data?.items ?? [];

      if (_response == null) {
        _response = res;
      } else {
        _response!.data!.items.addAll(newItems);
      }

      hasMore = res.data?.hasNextPage ?? false;
      _page++;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  /// RESET (optional)
  void reset() {
    _response = null;
    _page = 1;
    hasMore = true;
    error = null;
    notifyListeners();
  }
}
