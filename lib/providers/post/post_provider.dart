import 'dart:io';

import 'package:couple_mood_mobile/models/post/media_model.dart';
import 'package:couple_mood_mobile/models/upload_type.dart';
import 'package:couple_mood_mobile/utils/upload_util.dart';
import 'package:flutter/material.dart';
import '../../models/post/post_model.dart';
import '../../models/post/post_topic_model.dart';
import '../../services/post/post_service.dart';

class PostProvider extends ChangeNotifier {
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

  void toggleLikeById(int postId) {
    final post = posts.firstWhere((p) => p.id == postId);
    toggleLike(post);
  }
}
