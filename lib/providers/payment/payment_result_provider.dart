import 'package:flutter/material.dart';
import 'package:couple_mood_mobile/services/payment/payment_service.dart';
import 'package:couple_mood_mobile/models/payment/payment_status.dart';

class PaymentResultProvider extends ChangeNotifier {
  PaymentStatus? status;
  bool isLoading = false;
  String? error;

  Future<void> fetchStatus(String orderId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final res = await PaymentService.checkPaymentStatus(orderId);

      if (res.code == 200 && res.data != null) {
        status = res.data;
      } else {
        error = res.message;
      }
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  bool get isSuccess => status?.isActive == true;
}
