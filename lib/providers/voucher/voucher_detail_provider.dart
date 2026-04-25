import 'package:couple_mood_mobile/models/voucher/exchange_item.dart';
import 'package:couple_mood_mobile/models/voucher/voucher_item_model.dart';
import 'package:couple_mood_mobile/services/voucher/voucher_service.dart';
import 'package:flutter/foundation.dart';

class VoucherDetailProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isExchanging = false;
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

  Future<bool> exchangeVoucher() async {
    if (voucher == null) return false;

    isExchanging = true;
    notifyListeners();

    try {
      final res = await VoucherService.exchangeVoucher(
        items: [ExchangeItem(voucherId: voucher!.id, quantity: 1)],
      );

      if (res.code == 200) {
        return true;
      } else {
        error = res.message;
        return false;
      }
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isExchanging = false;
      notifyListeners();
    }
  }
}
