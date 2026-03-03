import 'package:couple_mood_mobile/models/paginated_response.dart';
import 'package:couple_mood_mobile/models/post/comment_model.dart';
import 'package:couple_mood_mobile/models/post/post_detail_model.dart';

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

  static Future<ApiResponse<PostDetailModel>> getPostDetail(int postId) async {
    final res = await ApiClient.request(
      '/Post/$postId',
      method: HttpMethod.get,
    );

    return ApiResponse.fromJson(res, (data) => PostDetailModel.fromJson(data));
  }

  static Future<ApiResponse<PaginatedResponse<CommentModel>>> getPostComments({
    required int postId,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    final res = await ApiClient.request(
      '/Post/$postId/comments',
      method: HttpMethod.get,
      query: {'pageNumber': pageNumber, 'pageSize': pageSize},
    );

    return ApiResponse.fromJson(
      res,
      (data) => PaginatedResponse.fromJson(
        data,
        (item) => CommentModel.fromJson(item),
      ),
    );
  }

  static Future<ApiResponse<PaginatedResponse<CommentModel>>>
  getCommentReplies({
    required int commentId,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    final res = await ApiClient.request(
      '/Comment/$commentId/replies',
      method: HttpMethod.get,
      query: {'pageNumber': pageNumber, 'pageSize': pageSize},
    );

    return ApiResponse.fromJson(
      res,
      (data) => PaginatedResponse.fromJson(
        data,
        (item) => CommentModel.fromJson(item),
      ),
    );
  }

  static Future<ApiResponse<dynamic>> likePost(int postId) async {
    final res = await ApiClient.request(
      '/Post/$postId/like',
      method: HttpMethod.post,
    );

    return ApiResponse.fromJson(res, (data) => data);
  }

  static Future<ApiResponse<dynamic>> unlikePost(int postId) async {
    final res = await ApiClient.request(
      '/Post/$postId/unlike',
      method: HttpMethod.delete,
    );

    return ApiResponse.fromJson(res, (data) => data);
  }
}
