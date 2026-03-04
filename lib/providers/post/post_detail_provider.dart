import 'package:flutter/material.dart';
import '../../models/post/comment_model.dart';
import '../../models/post/post_detail_model.dart';
import '../../services/post/post_service.dart';

class PostDetailProvider extends ChangeNotifier {
  PostDetailModel? post;

  /// ==============================
  /// ROOT COMMENTS (LEVEL 1)
  /// ==============================

  List<CommentModel> comments = [];

  bool loading = false;
  bool loadingComments = false;

  bool hasMoreComments = true;
  int currentPage = 1;

  /// ==============================
  /// REPLIES (LEVEL 2 & 3)
  /// ==============================

  /// Map<commentId, List<Reply>>
  final Map<int, List<CommentModel>> replies = {};

  /// Loading state riêng từng comment
  final Map<int, bool> loadingReplies = {};

  /// Track comment đã expand hay chưa
  final Set<int> expandedComments = {};

  /// Pagination riêng từng comment
  final Map<int, int> repliesPage = {};
  final Map<int, bool> repliesHasMore = {};

  /// ==============================
  /// INIT
  /// ==============================

  Future<void> init(int postId) async {
    currentPage = 1;
    hasMoreComments = true;

    comments.clear();
    replies.clear();
    repliesPage.clear();
    repliesHasMore.clear();
    loadingReplies.clear();

    await loadPostDetail(postId);
    await loadComments(postId);
  }

  /// ==============================
  /// LOAD POST DETAIL
  /// ==============================

  Future<void> loadPostDetail(int postId) async {
    loading = true;
    notifyListeners();

    try {
      final res = await PostService.getPostDetail(postId);
      if (res.code == 200) {
        post = res.data;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    loading = false;
    notifyListeners();
  }

  /// ==============================
  /// LOAD ROOT COMMENTS (LEVEL 1)
  /// ==============================

  Future<void> loadComments(int postId) async {
    if (loadingComments || !hasMoreComments) return;

    loadingComments = true;
    notifyListeners();

    try {
      final res = await PostService.getPostComments(
        postId: postId,
        pageNumber: currentPage,
      );

      if (res.code == 200 && res.data != null) {
        comments.addAll(res.data!.items);
        hasMoreComments = res.data!.hasNextPage;
        currentPage++;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    loadingComments = false;
    notifyListeners();
  }

  /// ==============================
  /// LOAD REPLIES (LEVEL 2 & 3)
  /// ==============================

  Future<void> loadReplies(CommentModel comment) async {
    if (comment.level >= 3) return;

    final commentId = comment.id;

    // Nếu đã expand rồi → collapse
    if (expandedComments.contains(commentId)) {
      expandedComments.remove(commentId);
      notifyListeners();
      return;
    }

    // Nếu chưa từng load thì gọi API
    if (!replies.containsKey(commentId)) {
      if (loadingReplies[commentId] == true) return;

      loadingReplies[commentId] = true;
      notifyListeners();

      try {
        final page = repliesPage[commentId] ?? 1;

        final res = await PostService.getCommentReplies(
          commentId: commentId,
          pageNumber: page,
        );

        if (res.code == 200 && res.data != null) {
          replies[commentId] = res.data!.items;
          repliesHasMore[commentId] = res.data!.hasNextPage;
          repliesPage[commentId] = page + 1;
        }
      } catch (e) {
        debugPrint(e.toString());
      }

      loadingReplies[commentId] = false;
    }

    // Đánh dấu expand
    expandedComments.add(commentId);

    notifyListeners();
  }

  Future<void> toggleLikeComment(CommentModel comment) async {
    final bool willLike = !comment.isLikedByMe;

    // Optimistic update (update UI trước)
    _updateCommentLikeLocal(comment.id, willLike);
    notifyListeners();

    try {
      final res = willLike
          ? await PostService.likeComment(comment.id)
          : await PostService.unlikeComment(comment.id);

      if (res.code != 200) {
        // Rollback nếu API fail
        _updateCommentLikeLocal(comment.id, !willLike);
        notifyListeners();
      }
    } catch (e) {
      //Rollback nếu lỗi mạng
      _updateCommentLikeLocal(comment.id, !willLike);
      notifyListeners();
      debugPrint(e.toString());
    }
  }

  Future<void> createComment({required String content, int? parentId}) async {
    if (post == null) return;

    try {
      final res = await PostService.createComment(
        postId: post!.id,
        content: content,
        parentId: parentId,
      );

      if (res.code == 200 && res.data != null) {
        final newComment = res.data!;

        if (parentId == null) {
          /// LEVEL 1
          comments.insert(0, newComment);
        } else {
          /// Tìm comment đang reply
          final replyingComment = _findCommentById(parentId);

          if (replyingComment == null) return;

          /// Nếu reply vào level 3 -> phải insert vào cha của nó
          final int insertParentId =
              replyingComment.level >= 3 && replyingComment.parentId != null
              ? replyingComment.parentId!
              : parentId;

          replies[insertParentId] ??= [];
          replies[insertParentId]!.insert(0, newComment);

          expandedComments.add(insertParentId);
        }

        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// ==============================
  /// HELPERS
  /// ==============================

  List<CommentModel> getReplies(int commentId) {
    if (!expandedComments.contains(commentId)) return [];
    return replies[commentId] ?? [];
  }

  bool isLoadingReplies(int commentId) {
    return loadingReplies[commentId] == true;
  }

  bool hasMoreReplies(int commentId) {
    return repliesHasMore[commentId] ?? true;
  }

  bool isExpanded(int commentId) {
    return expandedComments.contains(commentId);
  }

  void _updateCommentLikeLocal(int commentId, bool isLiked) {
    // Check root comments trước
    final rootIndex = comments.indexWhere((c) => c.id == commentId);
    if (rootIndex != -1) {
      final old = comments[rootIndex];

      comments[rootIndex] = old.copyWith(
        isLikedByMe: isLiked,
        likeCount: isLiked
            ? old.likeCount + 1
            : (old.likeCount > 0 ? old.likeCount - 1 : 0),
      );
      return;
    }

    // Check replies
    for (final entry in replies.entries) {
      final replyIndex = entry.value.indexWhere((c) => c.id == commentId);

      if (replyIndex != -1) {
        final old = entry.value[replyIndex];

        entry.value[replyIndex] = old.copyWith(
          isLikedByMe: isLiked,
          likeCount: isLiked
              ? old.likeCount + 1
              : (old.likeCount > 0 ? old.likeCount - 1 : 0),
        );
        return;
      }
    }
  }

  CommentModel? _findCommentById(int id) {
    // Check root comments
    for (final c in comments) {
      if (c.id == id) return c;
    }

    // Check replies
    for (final entry in replies.entries) {
      for (final c in entry.value) {
        if (c.id == id) return c;
      }
    }

    return null;
  }
}
