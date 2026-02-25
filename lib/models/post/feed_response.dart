import 'post_model.dart';

class FeedResponse {
  final List<PostModel> posts;
  final int? nextCursor;
  final bool hasMore;

  FeedResponse({
    required this.posts,
    required this.nextCursor,
    required this.hasMore,
  });

  factory FeedResponse.fromJson(Map<String, dynamic> json) {
    return FeedResponse(
      posts: (json['posts'] as List).map((e) => PostModel.fromJson(e)).toList(),
      nextCursor: json['nextCursor'],
      hasMore: json['hasMore'] ?? false,
    );
  }
}
