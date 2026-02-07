class VenueReview {
  final int id;
  final int rating;
  final String content;
  final int likeCount;
  final VenueReviewMember member;

  VenueReview({
    required this.id,
    required this.rating,
    required this.content,
    required this.likeCount,
    required this.member,
  });

  factory VenueReview.fromJson(Map<String, dynamic> json) {
    return VenueReview(
      id: json['id'],
      rating: json['rating'],
      content: json['content'],
      likeCount: json['likeCount'],
      member: VenueReviewMember.fromJson(json['member']),
    );
  }
}

class VenueReviewMember {
  final String displayName;
  final String avatarUrl;

  VenueReviewMember({required this.displayName, required this.avatarUrl});

  factory VenueReviewMember.fromJson(Map<String, dynamic> json) {
    return VenueReviewMember(
      displayName: json['displayName'],
      avatarUrl: json['avatarUrl'],
    );
  }
}
