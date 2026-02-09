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
}
