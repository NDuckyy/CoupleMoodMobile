import 'author_model.dart';

class CommentModel {
  final int id;
  final int? parentId;
  final String content;
  final int authorId;
  final AuthorModel author;

  final AuthorModel? replyToMember;
  final int rootId;
  final int level;

  final DateTime createdAt;
  final int likeCount;
  final int replyCount;

  final bool isLikedByMe;

  CommentModel({
    required this.id,
    this.parentId,
    required this.content,
    required this.authorId,
    required this.author,
    this.replyToMember,
    required this.rootId,
    required this.level,
    required this.createdAt,
    required this.likeCount,
    required this.replyCount,
    this.isLikedByMe = false,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      parentId: json['parentId'],
      content: json['content'] ?? '',
      authorId: json['authorId'],
      author: AuthorModel.fromJson(json['author']),
      replyToMember: json['replyToMember'] != null
          ? AuthorModel.fromJson(json['replyToMember'])
          : null,
      rootId: json['rootId'] ?? 0,
      level: json['level'] ?? 1,
      createdAt: DateTime.parse(json['createdAt']),
      likeCount: json['likeCount'] ?? 0,
      replyCount: json['replyCount'] ?? 0,
      isLikedByMe: json['isLikedByMe'] ?? false, // 👈 NEW
    );
  }

  ///  copyWith để immutable update
  CommentModel copyWith({int? likeCount, bool? isLikedByMe}) {
    return CommentModel(
      id: id,
      parentId: parentId,
      content: content,
      authorId: authorId,
      author: author,
      replyToMember: replyToMember,
      rootId: rootId,
      level: level,
      createdAt: createdAt,
      likeCount: likeCount ?? this.likeCount,
      replyCount: replyCount,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
    );
  }
}
