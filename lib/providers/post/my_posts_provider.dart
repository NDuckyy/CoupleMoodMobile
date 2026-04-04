import 'package:flutter/material.dart';
import '../../models/post/post_model.dart';
import '../../services/post/post_service.dart';

class MyPostsProvider extends ChangeNotifier {
  List<PostModel> posts = [];

  bool loading = false;
  bool loadingMore = false;

  int pageNumber = 1;
  final int pageSize = 10;

  bool hasMore = true;

  /// load first page
  Future<void> loadMyPosts() async {
    loading = true;
    notifyListeners();

    try {
      pageNumber = 1;

      final res = await PostService.getMyPosts(
        pageNumber: pageNumber,
        pageSize: pageSize,
      );

      if (res.code == 200 && res.data != null) {
        posts = res.data!; // giữ nguyên vì service trả về List
        hasMore =
            res.data!.length ==
            pageSize; // hoặc dùng totalPages nếu muốn chính xác hơn
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    loading = false;
    notifyListeners();
  }

  /// load next page
  Future<void> loadMore() async {
    if (!hasMore || loadingMore) return;

    loadingMore = true;
    notifyListeners();

    try {
      pageNumber++;

      final res = await PostService.getMyPosts(
        pageNumber: pageNumber,
        pageSize: pageSize,
      );

      if (res.code == 200 && res.data != null) {
        posts.addAll(res.data!);

        if (res.data!.length < pageSize) {
          hasMore = false;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    loadingMore = false;
    notifyListeners();
  }

  /// refresh
  Future<void> refresh() async {
    await loadMyPosts();
  }

  void updatePost(PostModel updatedPost) {
    final index = posts.indexWhere((p) => p.id == updatedPost.id);

    if (index != -1) {
      posts[index] = updatedPost;
      notifyListeners();
    }
  }

  void increaseCommentCount(int postId) {
    final index = posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final old = posts[index];

    posts[index] = old.copyWith(commentCount: old.commentCount + 1);

    notifyListeners();
  }

  void decreaseCommentCount(int postId) {
    final index = posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final old = posts[index];

    posts[index] = old.copyWith(
      commentCount: old.commentCount > 0 ? old.commentCount - 1 : 0,
    );

    notifyListeners();
  }
}
