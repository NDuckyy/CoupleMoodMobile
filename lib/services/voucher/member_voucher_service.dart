import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/paginated_response.dart';
import 'package:couple_mood_mobile/models/voucher/member_voucher_item_model.dart';
import 'package:couple_mood_mobile/services/api_client.dart';

class MemberVoucherService {
  static Future<ApiResponse<PaginatedResponse<MemberVoucherItem>>>
  getMemberVouchers({
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
        (item) => MemberVoucherItem.fromJson(item),
      ),
    );
  }
}
