import 'package:couple_mood_mobile/models/venue/venue_owner_profile.dart';

class VenueReviewReply {
  final int id;
  final int reviewId;
  final String content;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final VenueOwnerProfile? venueOwnerProfile;

  VenueReviewReply({
    required this.id,
    required this.reviewId,
    required this.content,
    this.createdAt,
    this.updatedAt,
    this.venueOwnerProfile,
  });

  factory VenueReviewReply.fromJson(Map<String, dynamic> json) {
    return VenueReviewReply(
      id: json['id'] ?? 0,
      reviewId: json['reviewId'] ?? 0,
      content: json['content'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      venueOwnerProfile: json['venueOwnerProfile'] != null
          ? VenueOwnerProfile.fromJson(json['venueOwnerProfile'])
          : null,
    );
  }
}
