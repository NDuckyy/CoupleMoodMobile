import 'package:couple_mood_mobile/models/voucher/voucher_item_model.dart';
import 'package:couple_mood_mobile/services/voucher/voucher_service.dart';
import 'package:flutter/material.dart';

class VoucherDetailProvider extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  VoucherItem? voucher;

  Future<void> fetchDetail(int id) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final res = await VoucherService.getVoucherDetail(id);

      if (res.code == 200) {
        voucher = res.data;
      } else {
        error = res.message;
      }
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
