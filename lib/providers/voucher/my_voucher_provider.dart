import 'package:couple_mood_mobile/models/voucher/member_voucher_item.dart';
import 'package:couple_mood_mobile/services/voucher/voucher_service.dart';
import 'package:flutter/material.dart';

class MyVoucherProvider extends ChangeNotifier {
  List<MemberVoucherItem> vouchers = [];
  bool loading = false;

  Future<void> fetchMyVouchers({
    int page = 1,
    int pageSize = 10,
    // String status = "ACQUIRED",
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
        // status: status,
      );

      if (res.code == 200) {
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
}
