import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/payment/momo_payment_data.dart';
import 'package:couple_mood_mobile/models/payment/payment_status.dart';
import 'package:couple_mood_mobile/services/api_client.dart';

class PaymentService {
  /// Gọi MOMO pay API
  static Future<ApiResponse<MomoPaymentData>> momoPay({
    required int packageId,
    String? description,
    String? couponCode,
  }) async {
    final res = await ApiClient.request(
      '/Payment/member/momo-pay',
      method: HttpMethod.post,
      data: {
        "packageId": packageId,
        "paymentMethod": "MOMO",
        "description": description,
        "couponCode": couponCode,
      },
    );

    return ApiResponse<MomoPaymentData>.fromJson(
      res as Map<String, dynamic>,
      (json) => MomoPaymentData.fromJson(json),
    );
  }

  /// Check trạng thái thanh toán bằng orderId
  static Future<ApiResponse<PaymentStatus>> checkPaymentStatus(
    String orderId,
  ) async {
    final res = await ApiClient.request(
      '/Payment/member/status/$orderId',
      method: HttpMethod.get,
    );

    return ApiResponse<PaymentStatus>.fromJson(
      res as Map<String, dynamic>,
      (json) => PaymentStatus.fromJson(json),
    );
  }

  static Future<ApiResponse<MomoPaymentData>> momoTopup({
    required int amount,
  }) async {
    if (amount < 1000) {
      throw "Số tiền tối thiểu là 1000 VND";
    }

    final res = await ApiClient.request(
      '/Payment/member/momo-topup',
      method: HttpMethod.post,
      data: {"amount": amount},
    );

    return ApiResponse<MomoPaymentData>.fromJson(
      res as Map<String, dynamic>,
      (json) => MomoPaymentData.fromJson(json),
    );
  }
}
