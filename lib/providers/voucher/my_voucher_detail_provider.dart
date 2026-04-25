import 'package:couple_mood_mobile/models/voucher/member_voucher_item.dart';
import 'package:couple_mood_mobile/services/voucher/voucher_service.dart';
import 'package:flutter/material.dart';

class MyVoucherDetailProvider extends ChangeNotifier {
  MemberVoucherItem? voucherDetail;
  bool loading = false;

  Future<void> fetchVoucherDetail(int voucherItemId) async {
    loading = true;
    notifyListeners();

    try {
      final res = await VoucherService.getMyVoucherDetail(voucherItemId);
      if (res.code == 200) {
        voucherDetail = res.data;
      } else {
        voucherDetail = null;
      }
    } catch (e) {
      debugPrint('Error fetching voucher detail: $e');
      voucherDetail = null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
