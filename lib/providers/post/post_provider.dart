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

    /// optimistic update
    final updatedPost = oldPost.copyWith(
      isLikedByMe: !oldLiked,
      likeCount: oldLiked ? oldPost.likeCount - 1 : oldPost.likeCount + 1,
    );

    posts[index] = updatedPost;
    notifyListeners();

    /// ✅ sync sang MyPosts
    myPostsProvider?.updatePost(updatedPost);

    try {
      final res = oldLiked
          ? await PostService.unlikePost(post.id)
          : await PostService.likePost(post.id);

      if (res.code == 200 && res.data != null) {
        final newPost = updatedPost.copyWith(
          isLikedByMe: res.data['isLikedByMe'],
          likeCount: res.data['postLikeCount'],
        );

        posts[index] = newPost;
        notifyListeners();

        /// sync lại
        myPostsProvider?.updatePost(newPost);
      }
    } catch (e) {
      /// rollback
      posts[index] = oldPost;
      notifyListeners();

      myPostsProvider?.updatePost(oldPost);
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
        /// add vào đầu feed
        posts.insert(0, res.data!);

        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
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
    final index = posts.indexWhere((p) => p.id == postId);
    if (index == -1) return false;

    try {
      /// upload ảnh mới
      List<String> newUrls = [];

      if (newMediaFiles.isNotEmpty) {
        newUrls = await UploadUtil.mediaUpload(newMediaFiles);
      }

      final newMedia = newUrls
          .map((url) => MediaModel(url: url, type: UploadType.image.value))
          .toList();

      /// merge ảnh cũ + mới
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
        posts[index] = res.data!;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
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

  void increaseCommentCount(int postId) {
    final index = posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final updated = posts[index].copyWith(
      commentCount: posts[index].commentCount + 1,
    );

    posts[index] = updated;
    notifyListeners();

    ///  sync
    myPostsProvider?.updatePost(updated);
  }

  void decreaseCommentCount(int postId) {
    final index = posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final updated = posts[index].copyWith(
      commentCount: posts[index].commentCount > 0
          ? posts[index].commentCount - 1
          : 0,
    );

    posts[index] = updated;
    notifyListeners();

    ///  sync
    myPostsProvider?.updatePost(updated);
  }

  void toggleLikeById(int postId) {
    final post = posts.firstWhere((p) => p.id == postId);
    toggleLike(post);
  }
}
