class VenueInAdvertisementDetail {
  final int venueId;
  final String venueName;
  final String venueAddress;
  final double venueAverageRating;
  final int venueReviewCount;
  final double venuePriceMin;
  final double venuePriceMax;
  final List<String> venueCoverImage;

  VenueInAdvertisementDetail({
    required this.venueId,
    required this.venueName,
    required this.venueAddress,
    required this.venueAverageRating,
    required this.venueReviewCount,
    required this.venuePriceMin,
    required this.venuePriceMax,
    required this.venueCoverImage,
  });

  factory VenueInAdvertisementDetail.fromJson(Map<String, dynamic> json) {
    return VenueInAdvertisementDetail(
      venueId: json['venueId'],
      venueName: json['venueName'],
      venueAddress: json['venueAddress'],
      venueAverageRating: (json['venueAverageRating'] as num).toDouble(),
      venueReviewCount: json['venueReviewCount'],
      venuePriceMin: json['venuePriceMin'],
      venuePriceMax: json['venuePriceMax'],
      venueCoverImage: List<String>.from(json['venueCoverImage']),
    );
  }
}