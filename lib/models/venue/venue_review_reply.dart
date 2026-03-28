class VenueReviewReply {
  final int id;
  final int reviewId;
  final int? venueId;
  final String content;

  final String? venueName;
  final List<String>? venueCoverImage;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  VenueReviewReply({
    required this.id,
    required this.reviewId,
    this.venueId,
    required this.content,
    this.venueName,
    this.venueCoverImage,
    this.createdAt,
    this.updatedAt,
  });

  factory VenueReviewReply.fromJson(Map<String, dynamic> json) {
    return VenueReviewReply(
      id: json['id'] ?? 0,
      reviewId: json['reviewId'] ?? 0,
      venueId: json['venueId'],
      content: json['content'] ?? '',
      venueName: json['venueName'],
      venueCoverImage: json['venueCoverImage'] != null
          ? List<String>.from(json['venueCoverImage'])
          : [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }
}
