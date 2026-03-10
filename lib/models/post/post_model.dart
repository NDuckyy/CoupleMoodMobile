import 'package:couple_mood_mobile/models/post/post_detail_model.dart';

import 'author_model.dart';
import 'media_model.dart';

class PostModel {
  final double? totalScore;
  final int id;
  final String content;
  final List<MediaModel> mediaPayload;
  final String? locationName;
  final List<String> hashTags;
  final List<String> topic;
  final int likeCount;
  final int commentCount;
  final DateTime createdAt;
  final int authorId;
  final bool isLikedByMe;
  final bool isOwner;
  final AuthorModel? author;

  PostModel({
    this.totalScore,
    required this.id,
    required this.content,
    required this.mediaPayload,
    required this.locationName,
    required this.hashTags,
    required this.topic,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
    required this.authorId,
    required this.isLikedByMe,
    required this.isOwner,
    this.author,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      totalScore: (json['totalScore'] ?? 0).toDouble(),
      id: json['id'],
      content: json['content'] ?? '',
      mediaPayload: (json['mediaPayload'] as List? ?? [])
          .map((e) => MediaModel.fromJson(e))
          .toList(),
      locationName: json['locationName'],
      hashTags: List<String>.from(json['hashTags'] ?? []),
      topic: List<String>.from(json['topic'] ?? []),
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      authorId: json['authorId'],
      isLikedByMe: json['isLikedByMe'] ?? false,
      isOwner: json['isOwner'] ?? false,
      author: json['author'] != null
          ? AuthorModel.fromJson(json['author'])
          : null,
    );
  }

  PostModel copyWith({
    double? totalScore,
    int? id,
    String? content,
    List<MediaModel>? mediaPayload,
    String? locationName,
    List<String>? hashTags,
    List<String>? topic,
    int? likeCount,
    int? commentCount,
    DateTime? createdAt,
    int? authorId,
    bool? isLikedByMe,
    bool? isOwner,
    AuthorModel? author,
  }) {
    return PostModel(
      totalScore: totalScore ?? this.totalScore,
      id: id ?? this.id,
      content: content ?? this.content,
      mediaPayload: mediaPayload ?? this.mediaPayload,
      locationName: locationName ?? this.locationName,
      hashTags: hashTags ?? this.hashTags,
      topic: topic ?? this.topic,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt ?? this.createdAt,
      authorId: authorId ?? this.authorId,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
      isOwner: isOwner ?? this.isOwner,
      author: author ?? this.author,
    );
  }

  factory PostModel.fromDetail(PostDetailModel detail) {
    return PostModel(
      id: detail.id,
      content: detail.content,
      mediaPayload: detail.mediaPayload,
      locationName: detail.locationName,
      hashTags: detail.hashTags,
      topic: detail.topic,
      likeCount: detail.likeCount,
      commentCount: detail.commentCount,
      createdAt: detail.createdAt,
      authorId: detail.authorId,
      isLikedByMe: detail.isLikedByMe,
      isOwner: detail.isOwner,
      author: detail.author,
    );
  }
}
