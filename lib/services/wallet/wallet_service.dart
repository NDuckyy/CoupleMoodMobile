import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/paginated_response.dart';
import 'package:couple_mood_mobile/models/wallet/convert_money_response.dart';
import 'package:couple_mood_mobile/models/wallet/exchange_rate.dart';
import 'package:couple_mood_mobile/models/wallet/wallet_transaction.dart';
import 'package:couple_mood_mobile/models/wallet/withdraw_request.dart';
import 'package:couple_mood_mobile/services/api_client.dart';

class WalletService {
  /// 🔹 GET exchange rate
  static Future<ApiResponse<ExchangeRate>> getExchangeRate() async {
    try {
      final res = await ApiClient.request(
        '/Wallet/member/exchange-rate',
        method: HttpMethod.get,
      );

      return ApiResponse<ExchangeRate>.fromJson(
        res,
        (json) => ExchangeRate.fromJson(json),
      );
    } catch (e) {
      throw Exception('Lỗi khi lấy tỉ lệ quy đổi: $e');
    }
  }

  /// 🔹 GET transactions (paginated)
  static Future<ApiResponse<PaginatedResponse<WalletTransaction>>>
  getTransactions({int page = 1, int pageSize = 20}) async {
    try {
      final res = await ApiClient.request(
        '/Wallet/member/transactions',
        method: HttpMethod.get,
        query: {'pageNumber': page, 'pageSize': pageSize},
      );

      return ApiResponse<PaginatedResponse<WalletTransaction>>.fromJson(
        res,
        (json) => PaginatedResponse<WalletTransaction>.fromJson(
          json,
          (e) => WalletTransaction.fromJson(e),
        ),
      );
    } catch (e) {
      print("❌ Error in getTransactions: $e"); // ← Thêm debug
      throw Exception('Lỗi khi lấy lịch sử giao dịch: $e');
    }
  }

  ///  POST convert money → point
  static Future<ApiResponse<ConvertMoneyResponse>> convertMoneyToPoint({
    required int amount,
  }) async {
    try {
      final res = await ApiClient.request(
        '/Wallet/convert-money-to-point',
        method: HttpMethod.post,
        data: {"amount": amount},
      );

      return ApiResponse<ConvertMoneyResponse>.fromJson(
        res,
        (json) => ConvertMoneyResponse.fromJson(json),
      );
    } catch (e) {
      throw Exception('Lỗi khi chuyển tiền thành điểm: $e');
    }
  }

  static Future<ApiResponse<WithdrawRequest>> withdraw({
    required int amount,
    required BankInfo bankInfo,
  }) async {
    try {
      final res = await ApiClient.request(
        '/Wallet/withdraw',
        method: HttpMethod.post,
        data: {"amount": amount, "bankInfo": bankInfo.toJson()},
      );

      return ApiResponse<WithdrawRequest>.fromJson(
        res,
        (json) => WithdrawRequest.fromJson(json),
      );
    } catch (e) {
      throw Exception('Lỗi khi tạo yêu cầu rút tiền: $e');
    }
  }

  static Future<ApiResponse<List<WithdrawRequest>>>
  getWithdrawRequests() async {
    try {
      final res = await ApiClient.request(
        '/Wallet/withdraw-requests',
        method: HttpMethod.get,
      );

      return ApiResponse<List<WithdrawRequest>>.fromJson(
        res,
        (json) =>
            (json as List).map((e) => WithdrawRequest.fromJson(e)).toList(),
      );
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách rút tiền: $e');
    }
  }
}
