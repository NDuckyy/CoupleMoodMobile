import 'package:couple_mood_mobile/models/paginated_response.dart';
import 'package:couple_mood_mobile/models/post/comment_model.dart';
import 'package:couple_mood_mobile/models/post/media_model.dart';
import 'package:couple_mood_mobile/models/post/post_detail_model.dart';
import 'package:couple_mood_mobile/models/post/post_model.dart';

import '../../models/api_response.dart';
import '../../models/post/feed_response.dart';
import '../../models/post/post_topic_model.dart';
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

  static Future<ApiResponse<PostModel>> createPost({
    required String content,
    required List<MediaModel> mediaPayload,
    String? locationName,
    required String visibility,
    List<String>? hashTags,
    List<String>? topic,
  }) async {
    final res = await ApiClient.request(
      '/Post',
      method: HttpMethod.post,
      data: {
        "content": content,
        "mediaPayload": mediaPayload.map((m) => m.toJson()).toList(),
        "locationName": locationName,
        "visibility": visibility,
        "hashTags": hashTags,
        "topic": topic,
      },
    );

    return ApiResponse.fromJson(res, (data) => PostModel.fromJson(data));
  }

  static Future<ApiResponse<PostModel>> updatePost({
    required int postId,
    required String content,
    required List<MediaModel> mediaPayload,
    String? locationName,
    required String visibility,
    List<String>? hashTags,
    List<String>? topic,
  }) async {
    final res = await ApiClient.request(
      '/Post/$postId',
      method: HttpMethod.put,
      data: {
        "content": content,
        "mediaPayload": mediaPayload.map((m) => m.toJson()).toList(),
        "locationName": locationName,
        "visibility": visibility,
        "hashTags": hashTags,
        "topic": topic,
      },
    );

    return ApiResponse.fromJson(res, (data) => PostModel.fromJson(data));
  }

  static Future<ApiResponse<bool>> deletePost(int postId) async {
    final res = await ApiClient.request(
      '/Post/$postId',
      method: HttpMethod.delete,
    );

    return ApiResponse.fromJson(res, (_) => true);
  }

  static Future<ApiResponse<List<PostTopic>>> getTopics() async {
    final res = await ApiClient.request("/Post/topics", method: HttpMethod.get);

    return ApiResponse.fromJson(
      res,
      (json) => (json as List).map((e) => PostTopic.fromJson(e)).toList(),
    );
  }

  static Future<ApiResponse<List<PostModel>>> getMyPosts({
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    final res = await ApiClient.request(
      '/Post/me',
      method: HttpMethod.get,
      query: {'pageNumber': pageNumber, 'pageSize': pageSize},
    );

    return ApiResponse.fromJson(
      res,
      (data) => (data as List).map((item) => PostModel.fromJson(item)).toList(),
    );
  }
}
