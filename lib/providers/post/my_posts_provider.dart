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
        posts = res.data!;
        hasMore = res.data!.length == pageSize;
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
}
