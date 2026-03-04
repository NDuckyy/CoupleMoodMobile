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

  static Future<ApiResponse<dynamic>> likeComment(int commentId) async {
    final res = await ApiClient.request(
      '/Comment/$commentId/like',
      method: HttpMethod.post,
    );

    return ApiResponse.fromJson(res, (data) => data);
  }

  static Future<ApiResponse<dynamic>> unlikeComment(int commentId) async {
    final res = await ApiClient.request(
      '/Comment/$commentId/unlike',
      method: HttpMethod.delete,
    );

    return ApiResponse.fromJson(res, (data) => data);
  }

  static Future<ApiResponse<CommentModel>> createComment({
    required int postId,
    required String content,
    int? parentId,
  }) async {
    final res = await ApiClient.request(
      '/Post/$postId/comment',
      method: HttpMethod.post,
      data: {
        "content": content,
        "parentId":
            parentId, // khỏi truyền cho nó là null nếu là comment level 1 cũng được
      },
    );

    return ApiResponse<CommentModel>.fromJson(
      res,
      (json) => CommentModel.fromJson(json),
    );
  }

  static Future<ApiResponse<CommentModel>> updateComment({
    required int commentId,
    required String content,
  }) async {
    final res = await ApiClient.request(
      '/Comment/$commentId',
      method: HttpMethod.put,
      data: {"content": content},
    );

    return ApiResponse<CommentModel>.fromJson(
      res,
      (json) => CommentModel.fromJson(json),
    );
  }

  static Future<ApiResponse<bool>> deleteComment({
    required int commentId,
  }) async {
    final res = await ApiClient.request(
      '/Comment/$commentId',
      method: HttpMethod.delete,
    );

    return ApiResponse<bool>.fromJson(res, (_) => true);
  }
}
