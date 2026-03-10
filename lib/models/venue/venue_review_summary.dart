class VenueReviewSummary {
  final double averageRating;
  final int totalReviews;
  final List<VenueRatingStat> ratings;

  VenueReviewSummary({
    required this.averageRating,
    required this.totalReviews,
    required this.ratings,
  });

  factory VenueReviewSummary.fromJson(Map<String, dynamic> json) {
    return VenueReviewSummary(
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: json['totalReviews'],
      ratings: (json['ratings'] as List)
          .map((e) => VenueRatingStat.fromJson(e))
          .toList(),
    );
  }
}

class VenueRatingStat {
  final int star;
  final int count;
  final double percent;

  VenueRatingStat({
    required this.star,
    required this.count,
    required this.percent,
  });

  factory VenueRatingStat.fromJson(Map<String, dynamic> json) {
    return VenueRatingStat(
      star: json['star'],
      count: json['count'],
      percent: (json['percent'] as num).toDouble(),
    );
  }
}
