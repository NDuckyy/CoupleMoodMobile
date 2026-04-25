import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/paginated_response.dart';
import 'package:couple_mood_mobile/models/voucher/exchange_item.dart';
import 'package:couple_mood_mobile/models/voucher/exchange_voucher_response.dart';
import 'package:couple_mood_mobile/models/voucher/member_voucher_item.dart';
import 'package:couple_mood_mobile/models/voucher/member_voucher_transaction.dart';
import 'package:couple_mood_mobile/models/voucher/voucher_item_model.dart';
import 'package:couple_mood_mobile/services/api_client.dart';

class VoucherService {
  static Future<ApiResponse<PaginatedResponse<VoucherItem>>> getVouchers({
    required int page,
    required int pageSize,
    String? keyword,
    int? locationId,
    String? sortBy,
    String? orderBy,
  }) async {
    final response = await ApiClient.request(
      '/member-vouchers',
      method: HttpMethod.get,
      query: {
        'PageNumber': page,
        'PageSize': pageSize,
        if (keyword != null && keyword.isNotEmpty) 'Keyword': keyword,
        if (locationId != null) 'LocationId': locationId,
        if (sortBy != null) 'SortBy': sortBy,
        if (orderBy != null) 'OrderBy': orderBy,
      },
    );

    return ApiResponse.fromJson(
      response,
      (data) => PaginatedResponse.fromJson(
        data,
        (item) => VoucherItem.fromJson(item),
      ),
    );
  }

  static Future<ApiResponse<VoucherItem>> getVoucherDetail(
    int voucherId,
  ) async {
    final response = await ApiClient.request(
      '/member-vouchers/$voucherId',
      method: HttpMethod.get,
    );

    return ApiResponse.fromJson(response, (data) => VoucherItem.fromJson(data));
  }

  static Future<ApiResponse<ExchangeVoucherResponse>> exchangeVoucher({
    required List<ExchangeItem> items,
    String? note,
  }) async {
    final res = await ApiClient.request(
      '/member-vouchers/exchange',
      method: HttpMethod.post,
      data: {'items': items.map((e) => e.toJson()).toList(), 'note': note},
    );

    return ApiResponse<ExchangeVoucherResponse>.fromJson(
      res,
      (json) => ExchangeVoucherResponse.fromJson(json),
    );
  }

  static Future<ApiResponse<PaginatedResponse<MemberVoucherItem>>>
  getMyVouchers({
    required int page,
    required int pageSize,
    String? keyword,
    int? voucherId,
    String? status, // ACQUIRED, USED, EXPIRED
    String? sortBy,
    String? orderBy,
  }) async {
    final res = await ApiClient.request(
      '/member-vouchers/my-vouchers',
      method: HttpMethod.get,
      query: {
        'PageNumber': page,
        'PageSize': pageSize,
        if (keyword != null && keyword.isNotEmpty) 'Keyword': keyword,
        if (voucherId != null) 'VoucherId': voucherId,
        if (status != null) 'Status': status,
        if (sortBy != null) 'SortBy': sortBy,
        if (orderBy != null) 'OrderBy': orderBy,
      },
    );

    return ApiResponse.fromJson(
      res,
      (data) => PaginatedResponse.fromJson(
        data,
        (item) => MemberVoucherItem.fromJson(item),
      ),
    );
  }

  static Future<ApiResponse<MemberVoucherItem>> getMyVoucherDetail(
    int voucherItemId,
  ) async {
    final res = await ApiClient.request(
      '/member-vouchers/my-vouchers/$voucherItemId',
      method: HttpMethod.get,
    );

    return ApiResponse.fromJson(
      res,
      (json) => MemberVoucherItem.fromJson(json),
    );
  }

  static Future<ApiResponse<PaginatedResponse<MemberVoucherTransaction>>>
  getVoucherTransactions({
    required int page,
    required int pageSize,
    String? keyword,
    String? fromDate,
    String? toDate,
    String? sortBy,
    String? orderBy,
  }) async {
    final res = await ApiClient.request(
      '/member-vouchers/transactions',
      method: HttpMethod.get,
      query: {
        'PageNumber': page,
        'PageSize': pageSize,
        if (keyword != null && keyword.isNotEmpty) 'Keyword': keyword,
        if (fromDate != null) 'FromDate': fromDate,
        if (toDate != null) 'ToDate': toDate,
        if (sortBy != null) 'SortBy': sortBy,
        if (orderBy != null) 'OrderBy': orderBy,
      },
    );

    return ApiResponse.fromJson(
      res,
      (data) => PaginatedResponse.fromJson(
        data,
        (item) => MemberVoucherTransaction.fromJson(item),
      ),
    );
  }

  static Future<ApiResponse<MemberVoucherTransaction>>
  getVoucherTransactionDetail(int voucherItemMemberId) async {
    final res = await ApiClient.request(
      '/member-vouchers/transactions/$voucherItemMemberId',
      method: HttpMethod.get,
    );

    return ApiResponse.fromJson(
      res,
      (json) => MemberVoucherTransaction.fromJson(json),
    );
  }
}
