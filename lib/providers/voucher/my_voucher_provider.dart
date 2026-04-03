import 'package:couple_mood_mobile/models/voucher/member_voucher_item.dart';
import 'package:couple_mood_mobile/services/voucher/voucher_service.dart';
import 'package:flutter/material.dart';

class MyVoucherProvider extends ChangeNotifier {
  List<MemberVoucherItem> vouchers = [];
  bool loading = false;

  // Filter & Sort
  String? _keyword;
  String _status = "ACQUIRED"; // mặc định là Acquired
  String _sortBy = "updatedAt"; // mặc định sort theo updatedAt
  String _orderBy = "desc"; // mặc định giảm dần

  String? get keyword => _keyword;
  String get status => _status;

  // Getter cho UI
  String get currentStatusDisplay {
    switch (_status) {
      case "ACQUIRED":
        return "Sẵn sàng";
      case "USED":
        return "Đã dùng";
      case "EXPIRED":
        return "Hết hạn";
      default:
        return "Tất cả";
    }
  }

  Future<void> fetchMyVouchers({
    int page = 1,
    int pageSize = 20,
    bool refresh = false,
  }) async {
    if (refresh) {
      vouchers = [];
      notifyListeners();
    }

    loading = true;
    notifyListeners();

    try {
      final res = await VoucherService.getMyVouchers(
        page: page,
        pageSize: pageSize,
        keyword: _keyword,
        status: _status == "ALL" ? null : _status,
        sortBy: _sortBy,
        orderBy: _orderBy,
      );

      if (res.code == 200 && res.data != null) {
        vouchers = res.data!.items;
      } else {
        vouchers = [];
      }
    } catch (e) {
      debugPrint('Error fetching my vouchers: $e');
      vouchers = [];
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Cập nhật từ UI
  void setStatus(String newStatus) {
    if (_status == newStatus) return;
    _status = newStatus;
    notifyListeners();
    fetchMyVouchers(refresh: true);
  }

  void setKeyword(String? keyword) {
    _keyword = keyword?.trim().isEmpty == true ? null : keyword?.trim();
    notifyListeners();
  }

  void search() {
    fetchMyVouchers(refresh: true);
  }

  // Reset filter
  void resetFilter() {
    _keyword = null;
    _status = "ACQUIRED";
    notifyListeners();
    fetchMyVouchers(refresh: true);
  }
}
