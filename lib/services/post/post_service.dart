import '../../models/api_response.dart';
import '../../models/post/feed_response.dart';
import '../api_client.dart';

class PostService {
  static Future<ApiResponse<FeedResponse>> getFeeds({
    int pageSize = 10,
    int? cursor,
    double? lat,
    double? lng,
  }) async {
    final res = await ApiClient.request(
      '/Post/feeds',
      method: HttpMethod.get,
      query: {
        'PageSize': pageSize,
        if (cursor != null) 'Cursor': cursor,
        if (lat != null) 'CurrentLatitude': lat,
        if (lng != null) 'CurrentLongitude': lng,
      },
    );

    return ApiResponse.fromJson(res, (data) => FeedResponse.fromJson(data));
  }
}
