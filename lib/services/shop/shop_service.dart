import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/paginated_response.dart';
import 'package:couple_mood_mobile/models/venue/member_accessory.dart';
import 'package:couple_mood_mobile/services/api_client.dart';

class MemberAccessoryService {
  static Future<ApiResponse<PaginatedResponse<MemberAccessory>>> getShop({
    int page = 1,
    int pageSize = 10,
    String? keyword,
    String? type,
    String sortBy = 'createdAt',
    String orderBy = 'desc',
  }) async {
    final query = {
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString(),
      'SortBy': sortBy,
      'OrderBy': orderBy,
      if (keyword != null) 'Keyword': keyword,
      if (type != null) 'Type': type,
    };

    final res = await ApiClient.request(
      '/MemberAccessory/shop',
      method: HttpMethod.get,
      query: query,
    );

    return ApiResponse.fromJson(
      res,
      (json) => PaginatedResponse<MemberAccessory>.fromJson(
        json,
        (item) => MemberAccessory.fromJson(item),
      ),
    );
  }
}
