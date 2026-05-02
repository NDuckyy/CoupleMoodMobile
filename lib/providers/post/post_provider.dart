import 'dart:io';

import 'package:couple_mood_mobile/models/post/media_model.dart';
import 'package:couple_mood_mobile/models/upload_type.dart';
import 'package:couple_mood_mobile/providers/post/my_posts_provider.dart';
import 'package:couple_mood_mobile/utils/upload_util.dart';
import 'package:flutter/material.dart';
import '../../models/post/post_model.dart';
import '../../models/post/post_topic_model.dart';
import '../../services/post/post_service.dart';

class PostProvider extends ChangeNotifier {
  MyPostsProvider? myPostsProvider;

  PostProvider(this.myPostsProvider);

  void setMyPostsProvider(MyPostsProvider provider) {
    myPostsProvider = provider;
  }

  List<PostModel> posts = [];
  bool loading = false;
  bool loadingMore = false;
  bool hasMore = true;
  int? nextCursor;

  List<PostTopic> topics = [];
  bool loadingTopics = false;

  final Set<int> _likingPostIds = {};

  String? error;

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
    /// tìm ở FEED trước
    int index = posts.indexWhere((p) => p.id == post.id);

    /// nếu không có → fallback sang MyPosts
    if (index == -1) {
      final myIndex = myPostsProvider?.posts.indexWhere((p) => p.id == post.id);

      if (myIndex == null || myIndex == -1) return;

      final current = myPostsProvider!.posts[myIndex];
      await _handleLikeLogic(current, isFromMyPosts: true, myIndex: myIndex);
      return;
    }

    final current = posts[index];
    await _handleLikeLogic(current, index: index);
  }

  Future<void> _handleLikeLogic(
    PostModel current, {
    int? index,
    bool isFromMyPosts = false,
    int? myIndex,
  }) async {
    if (_likingPostIds.contains(current.id)) return;
    _likingPostIds.add(current.id);

    final oldLiked = current.isLikedByMe;

    final updatedPost = current.copyWith(
      isLikedByMe: !oldLiked,
      likeCount: oldLiked ? current.likeCount - 1 : current.likeCount + 1,
    );

    /// update UI ngay
    if (index != null) posts[index] = updatedPost;
    if (isFromMyPosts && myIndex != null) {
      myPostsProvider!.posts[myIndex] = updatedPost;
    }

    notifyListeners();
    myPostsProvider?.updatePost(updatedPost);

    try {
      final res = oldLiked
          ? await PostService.unlikePost(current.id)
          : await PostService.likePost(current.id);

      if (res.code == 200 && res.data != null) {
        final newPost = updatedPost.copyWith(
          isLikedByMe: res.data['isLikedByMe'],
          likeCount: res.data['postLikeCount'],
        );

        if (index != null) posts[index] = newPost;
        if (isFromMyPosts && myIndex != null) {
          myPostsProvider!.posts[myIndex] = newPost;
        }

        notifyListeners();
        myPostsProvider?.updatePost(newPost);
      } else {
        throw Exception();
      }
    } catch (e) {
      /// rollback
      if (index != null) posts[index] = current;
      if (isFromMyPosts && myIndex != null) {
        myPostsProvider!.posts[myIndex] = current;
      }

      notifyListeners();
      myPostsProvider?.updatePost(current);
    } finally {
      _likingPostIds.remove(current.id);
    }
  }

  Future<bool> createPost({
    required String content,
    required List<File> mediaFiles,
    String visibility = "PUBLIC",
    String? locationName,
    List<String>? hashTags,
    List<String>? topic,
  }) async {
    error = null;
    try {
      /// 1 upload images lên S3
      final urls = await UploadUtil.mediaUpload(mediaFiles);

      /// 2 convert thành MediaModel
      final mediaPayload = urls
          .map((url) => MediaModel(url: url, type: UploadType.image.value))
          .toList();

      /// 3 call API
      final res = await PostService.createPost(
        content: content,
        mediaPayload: mediaPayload,
        visibility: visibility,
        locationName: locationName,
        hashTags: hashTags,
        topic: topic,
      );

      if (res.code == 200 && res.data != null) {
        posts.insert(0, res.data!);
        notifyListeners();
        return true;
      } else {
        error = res.message ?? "Không thể tạo bài viết";
        return false;
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '').trim();
      debugPrint("Create post error: $e");
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> updatePost({
    required int postId,
    required String content,
    required List<File> newMediaFiles,
    required List<MediaModel> oldMedia,
    String visibility = "PUBLIC",
    String? locationName,
    List<String>? hashTags,
    List<String>? topic,
  }) async {
    /// tìm trong feed
    int index = posts.indexWhere((p) => p.id == postId);

    /// fallback sang MyPosts
    int? myIndex;
    if (index == -1) {
      myIndex = myPostsProvider?.posts.indexWhere((p) => p.id == postId);
      if (myIndex == null || myIndex == -1) return false;
    }

    try {
      /// upload ảnh mới
      List<String> newUrls = [];
      if (newMediaFiles.isNotEmpty) {
        newUrls = await UploadUtil.mediaUpload(newMediaFiles);
      }

      final newMedia = newUrls
          .map((url) => MediaModel(url: url, type: UploadType.image.value))
          .toList();

      final mediaPayload = [...oldMedia, ...newMedia];

      final res = await PostService.updatePost(
        postId: postId,
        content: content,
        mediaPayload: mediaPayload,
        visibility: visibility,
        locationName: locationName,
        hashTags: hashTags,
        topic: topic,
      );

      if (res.code == 200 && res.data != null) {
        final updated = res.data!;

        /// update FEED nếu có
        if (index != -1) {
          posts[index] = updated;
        }

        /// update MyPosts nếu có
        if (myIndex != null && myIndex != -1) {
          myPostsProvider!.posts[myIndex] = updated;
        }

        notifyListeners();
        myPostsProvider?.updatePost(updated);

        return true;
      }

      return false;
    } catch (e) {
      debugPrint("Update post error: $e");
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> deletePost(int postId) async {
    final index = posts.indexWhere((p) => p.id == postId);

    if (index == -1) return false;

    final removed = posts.removeAt(index);

    notifyListeners();

    try {
      final res = await PostService.deletePost(postId);

      if (res.code != 200) {
        /// rollback nếu API fail
        posts.insert(index, removed);

        notifyListeners();

        return false;
      }

      return true;
    } catch (e) {
      posts.insert(index, removed);

      notifyListeners();

      return false;
    }
  }

  Future<void> loadTopics() async {
    loadingTopics = true;
    notifyListeners();

    try {
      final res = await PostService.getTopics();

      if (res.code == 200 && res.data != null) {
        topics = res.data!;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    loadingTopics = false;
    notifyListeners();
  }

  Future<String?> getShareLink(int postId) async {
    try {
      final res = await PostService.getShareLink(postId);

      if (res.code == 200 && res.data != null) {
        return res.data!.shareLinkUrl;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  void increaseCommentCount(int postId) {
    final index = posts.indexWhere((p) => p.id == postId);

    if (index != -1) {
      final updated = posts[index].copyWith(
        commentCount: posts[index].commentCount + 1,
      );
      posts[index] = updated;
      notifyListeners();
      myPostsProvider?.updatePost(updated);
      return;
    }

    /// fallback MyPosts
    myPostsProvider?.increaseCommentCount(postId);
  }

  void decreaseCommentCount(int postId) {
    final index = posts.indexWhere((p) => p.id == postId);

    /// ✅ nếu có trong FEED
    if (index != -1) {
      final updated = posts[index].copyWith(
        commentCount: posts[index].commentCount > 0
            ? posts[index].commentCount - 1
            : 0,
      );

      posts[index] = updated;
      notifyListeners();

      /// sync sang MyPosts
      myPostsProvider?.updatePost(updated);
      return;
    }

    ///  fallback sang MyPosts
    final myIndex = myPostsProvider?.posts.indexWhere((p) => p.id == postId);

    if (myIndex != null && myIndex != -1) {
      final old = myPostsProvider!.posts[myIndex];

      final updated = old.copyWith(
        commentCount: old.commentCount > 0 ? old.commentCount - 1 : 0,
      );

      myPostsProvider!.posts[myIndex] = updated;
      myPostsProvider!.notifyListeners();
    }
  }

  void toggleLikeById(int postId) {
    final post = findPostById(postId);
    if (post == null) return;

    toggleLike(post);
  }

  PostModel? findPostById(int postId) {
    /// 1. tìm trong feed
    final feedIndex = posts.indexWhere((p) => p.id == postId);
    if (feedIndex != -1) return posts[feedIndex];

    /// 2. fallback qua myPosts
    final myIndex = myPostsProvider?.posts.indexWhere((p) => p.id == postId);
    if (myIndex != null && myIndex != -1) {
      return myPostsProvider!.posts[myIndex];
    }

    return null;
  }
}
