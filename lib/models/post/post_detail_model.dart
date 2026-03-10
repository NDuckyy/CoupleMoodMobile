import 'author_model.dart';
import 'media_model.dart';

class PostDetailModel {
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
  final AuthorModel author;

  PostDetailModel({
    required this.id,
    required this.content,
    required this.mediaPayload,
    this.locationName,
    required this.hashTags,
    required this.topic,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
    required this.authorId,
    required this.isLikedByMe,
    required this.isOwner,
    required this.author,
  });

  factory PostDetailModel.fromJson(Map<String, dynamic> json) {
    return PostDetailModel(
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
      createdAt: DateTime.parse(json['createdAt']),
      authorId: json['authorId'],
      isLikedByMe: json['isLikedByMe'] ?? false,
      isOwner: json['isOwner'] ?? false,
      author: AuthorModel.fromJson(json['author']),
    );
  }

  PostDetailModel copyWith({
    String? content,
    List<MediaModel>? mediaPayload,
    String? locationName,
    List<String>? hashTags,
    List<String>? topic,
    int? likeCount,
    int? commentCount,
    bool? isLikedByMe,
    bool? isOwner,
  }) {
    return PostDetailModel(
      id: id,
      content: content ?? this.content,
      mediaPayload: mediaPayload ?? this.mediaPayload,
      locationName: locationName ?? this.locationName,
      hashTags: hashTags ?? this.hashTags,
      topic: topic ?? this.topic,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt,
      authorId: authorId,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
      isOwner: isOwner ?? this.isOwner,
      author: author,
    );
  }
}
