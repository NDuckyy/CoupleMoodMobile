import 'package:flutter/material.dart';
import '../../models/post/post_model.dart';
import '../../services/post/post_service.dart';

class PostProvider extends ChangeNotifier {
  List<PostModel> posts = [];
  bool loading = false;
  bool loadingMore = false;
  bool hasMore = true;
  int? nextCursor;

  Future<void> loadFeeds() async {
    loading = true;
    notifyListeners();

    try {
      final res = await PostService.getFeeds();

      if (res.code == 200 && res.data != null) {
        posts = res.data!.posts;
        nextCursor = res.data!.nextCursor;
        hasMore = res.data!.hasMore;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    loading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (!hasMore || loadingMore) return;

    loadingMore = true;
    notifyListeners();

    try {
      final res = await PostService.getFeeds(cursor: nextCursor);

      if (res.code == 200 && res.data != null) {
        posts.addAll(res.data!.posts);
        nextCursor = res.data!.nextCursor;
        hasMore = res.data!.hasMore;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    loadingMore = false;
    notifyListeners();
  }

  Future<void> toggleLike(PostModel post) async {
    final index = posts.indexWhere((p) => p.id == post.id);
    if (index == -1) return;

    final oldPost = posts[index];
    final oldLiked = oldPost.isLikedByMe;

    // optimistic update
    posts[index] = oldPost.copyWith(
      isLikedByMe: !oldLiked,
      likeCount: oldLiked ? oldPost.likeCount - 1 : oldPost.likeCount + 1,
    );

    notifyListeners();

    try {
      final res = oldLiked
          ? await PostService.unlikePost(post.id)
          : await PostService.likePost(post.id);

      if (res.code == 200 && res.data != null) {
        posts[index] = posts[index].copyWith(
          isLikedByMe: res.data['isLikedByMe'],
          likeCount: res.data['postLikeCount'],
        );
        notifyListeners();
      }
    } catch (e) {
      // rollback
      posts[index] = oldPost;
      notifyListeners();
    }
  }
}
