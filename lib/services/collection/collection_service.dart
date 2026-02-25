import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/collection/collection_item.dart';
import 'package:couple_mood_mobile/models/paginated_response.dart';
import 'package:couple_mood_mobile/services/api_client.dart';

class CollectionService {
  static Future<ApiResponse<PaginatedResponse<CollectionItem>>>
  getMyCollections({int page = 1, int pageSize = 10}) async {
    try {
      final res = await ApiClient.request(
        '/Collection/my-collections',
        method: HttpMethod.get,
        query: {'page': page, 'pageSize': pageSize},
      );

      return ApiResponse<PaginatedResponse<CollectionItem>>.fromJson(
        res,
        (json) => PaginatedResponse<CollectionItem>.fromJson(
          json,
          (e) => CollectionItem.fromJson(e),
        ),
      );
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách collection: $e');
    }
  }

  static Future<ApiResponse<CollectionItem>> getCollectionDetail(int id) async {
    final res = await ApiClient.request(
      '/Collection/$id',
      method: HttpMethod.get,
    );

    return ApiResponse<CollectionItem>.fromJson(
      res as Map<String, dynamic>,
      (json) => CollectionItem.fromJson(json),
    );
  }

  static Future<ApiResponse<CollectionItem>> createCollection({
    required String name,
    required String description,
    required String imgUrl,
    required String status,
  }) async {
    final res = await ApiClient.request(
      '/Collection',
      method: HttpMethod.post,
      data: {
        "collectionName": name,
        "description": description,
        "img": imgUrl,
        "status": status,
      },
    );

    return ApiResponse<CollectionItem>.fromJson(
      res,
      (json) => CollectionItem.fromJson(json),
    );
  }

  static Future<ApiResponse<CollectionItem>> updateCollection({
    required int id,
    required String name,
    required String description,
    required String imgUrl,
    required String status,
  }) async {
    final res = await ApiClient.request(
      '/Collection/$id',
      method: HttpMethod.put,
      data: {
        "collectionName": name,
        "description": description,
        "img": imgUrl,
        "status": status,
      },
    );

    return ApiResponse<CollectionItem>.fromJson(
      res,
      (json) => CollectionItem.fromJson(json),
    );
  }

  static Future<ApiResponse<void>> deleteCollection(int id) async {
    try {
      final res = await ApiClient.request(
        '/Collection/$id',
        method: HttpMethod.delete,
      );

      return ApiResponse<void>.fromJson(res, (_) => null);
    } catch (e) {
      throw Exception('Lỗi khi xoá collection: $e');
    }
  }

  static Future<ApiResponse<void>> removeVenuesFromCollection({
    required int collectionId,
    required List<int> venueIds,
  }) async {
    try {
      final res = await ApiClient.request(
        '/Collection/$collectionId/remove-venues',
        method: HttpMethod.patch,
        data: {"venueIds": venueIds},
      );

      return ApiResponse<void>.fromJson(res, (_) => null);
    } catch (e) {
      throw Exception('Lỗi khi xoá địa điểm khỏi collection: $e');
    }
  }

  static Future<ApiResponse<CollectionItem>> getCurrentCollection() async {
    final res = await ApiClient.request(
      '/Collection/current',
      method: HttpMethod.get,
    );

    return ApiResponse<CollectionItem>.fromJson(
      res,
      (json) => CollectionItem.fromJson(json),
    );
  }

  static Future<ApiResponse<void>> addVenueToCollection({
    required int collectionId,
    required int venueId,
  }) async {
    final res = await ApiClient.request(
      '/Collection/$collectionId/venue/$venueId',
      method: HttpMethod.post,
    );

    return ApiResponse<void>.fromJson(res, (_) => null);
  }

  static Future<ApiResponse<void>> addVenuesToCollection({
    required int collectionId,
    required List<int> venueIds,
  }) async {
    final res = await ApiClient.request(
      '/Collection/$collectionId/add-venues',
      method: HttpMethod.patch,
      data: {"venueIds": venueIds},
    );

    return ApiResponse<void>.fromJson(res, (_) => null);
  }
}
