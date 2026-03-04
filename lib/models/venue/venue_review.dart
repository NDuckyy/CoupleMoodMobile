class VenueReview {
  final int id;
  final int venueId;
  final int rating;
  final String content;
  final DateTime? visitedAt;
  final bool isAnonymous;
  final int likeCount;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final VenueReviewMember member;
  final List<String> imageUrls;
  final String? matchedTag;

  VenueReview({
    required this.id,
    required this.venueId,
    required this.rating,
    required this.content,
    required this.visitedAt,
    required this.isAnonymous,
    required this.likeCount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.member,
    required this.imageUrls,
    this.matchedTag,
  });

  factory VenueReview.fromJson(Map<String, dynamic> json) {
    return VenueReview(
      id: json['id'],
      venueId: json['venueId'],
      rating: json['rating'],
      content: json['content'],
      visitedAt: json['visitedAt'] != null
          ? DateTime.parse(json['visitedAt'])
          : null,
      isAnonymous: json['isAnonymous'] ?? false,
      likeCount: json['likeCount'] ?? 0,
      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      member: VenueReviewMember.fromJson(json['member']),
      imageUrls:
          (json['imageUrls'] as List?)?.map((e) => e.toString()).toList() ?? [],
      matchedTag: json['matchedTag'],
    );
  }
}

class VenueReviewMember {
  final int id;
  final int userId;
  final String fullName;
  final String displayName;
  final String gender;
  final String? bio;
  final String avatarUrl;
  final String email;

  VenueReviewMember({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.displayName,
    required this.gender,
    required this.bio,
    required this.avatarUrl,
    required this.email,
  });

  factory VenueReviewMember.fromJson(Map<String, dynamic> json) {
    return VenueReviewMember(
      id: json['id'],
      userId: json['userId'],
      fullName: json['fullName'] ?? '',
      displayName: json['displayName'] ?? '',
      gender: json['gender'] ?? '',
      bio: json['bio'],
      avatarUrl: json['avatarUrl'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
