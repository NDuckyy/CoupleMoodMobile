import 'package:couple_mood_mobile/models/venue/venue_review_member.dart';
import 'package:couple_mood_mobile/models/venue/venue_review_reply.dart';

class VenueReview {
  final int id;
  final int venueId;
  final int rating;
  final String content;
  final DateTime? visitedAt;
  final bool isAnonymous;

  int likeCount;
  bool isLikedByMe;

  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final VenueReviewMember member;
  final List<String> imageUrls;
  final bool? isMatched;

  final bool isOwner;
  final VenueReviewReply? reviewReply;

  VenueReview({
    required this.id,
    required this.venueId,
    required this.rating,
    required this.content,
    required this.visitedAt,
    required this.isAnonymous,
    required this.likeCount,
    required this.isLikedByMe,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.member,
    required this.imageUrls,
    this.isMatched,
    required this.isOwner,
    this.reviewReply,
  });

  factory VenueReview.fromJson(Map<String, dynamic> json) {
    return VenueReview(
      id: json['id'] ?? 0,
      venueId: json['venueId'] ?? 0,
      rating: json['rating'] ?? 0,
      content: json['content'] ?? '',
      visitedAt: json['visitedAt'] != null
          ? DateTime.tryParse(json['visitedAt'])
          : null,
      isAnonymous: json['isAnonymous'] ?? false,

      likeCount: json['likeCount'] ?? 0,
      isLikedByMe: json['isLikedByMe'] ?? false,

      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      member: VenueReviewMember.fromJson(json['member']),
      imageUrls:
          (json['imageUrls'] as List?)?.map((e) => e.toString()).toList() ?? [],
      isMatched: json['isMatched'],
      isOwner: json['isOwner'] ?? false,
      reviewReply: json['reviewReply'] != null
          ? VenueReviewReply.fromJson(json['reviewReply'])
          : null,
    );
  }
}
