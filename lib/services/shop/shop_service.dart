import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/paginated_response.dart';
import 'package:couple_mood_mobile/models/venue/member_accessory.dart';
import 'package:couple_mood_mobile/services/api_client.dart';

class MemberAccessoryService {
  /// ===== SHOP =====
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

  /// ===== INVENTORY =====
  static Future<ApiResponse<PaginatedResponse<MemberAccessory>>>
  getMyAccessories({
    int page = 1,
    int pageSize = 10,
    bool? equippedOnly,
    String? type,
    String? keyword,
    String sortBy = 'acquiredAt',
    String orderBy = 'desc',
  }) async {
    final query = {
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString(),
      'SortBy': sortBy,
      'OrderBy': orderBy,
      if (equippedOnly != null) 'EquippedOnly': equippedOnly.toString(),
      if (type != null) 'Type': type,
      if (keyword != null && keyword.isNotEmpty) 'Keyword': keyword,
    };

    final res = await ApiClient.request(
      '/MemberAccessory/me',
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

  /// ===== EQUIP =====
  static Future<ApiResponse<MemberAccessory>> equip(
    int memberAccessoryId,
  ) async {
    final res = await ApiClient.request(
      '/MemberAccessory/me/$memberAccessoryId/equip',
      method: HttpMethod.post,
    );

    return ApiResponse.fromJson(res, (json) => MemberAccessory.fromJson(json));
  }

  /// ===== UNEQUIP =====
  static Future<ApiResponse<MemberAccessory>> unequip(
    int memberAccessoryId,
  ) async {
    final res = await ApiClient.request(
      '/MemberAccessory/me/$memberAccessoryId/unequip',
      method: HttpMethod.post,
    );

    return ApiResponse.fromJson(res, (json) => MemberAccessory.fromJson(json));
  }

  /// ===== PURCHASE =====
  static Future<ApiResponse<dynamic>> purchase(int accessoryId) async {
    final res = await ApiClient.request(
      '/MemberAccessory/shop/$accessoryId/purchase',
      method: HttpMethod.post,
    );

    return ApiResponse.fromJson(res, (json) => json);
  }
}
