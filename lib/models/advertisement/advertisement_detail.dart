import 'package:couple_mood_mobile/models/advertisement/venue_in_advertisement_detail.dart';

class AdvertisementDetail {
  final int advertisementId;
  final String title;
  final String content;
  final String bannerUrl;
  final String targetUrl;
  final String placementType;
  final List<VenueInAdvertisementDetail> venues;

  AdvertisementDetail({
    required this.advertisementId,
    required this.title,
    required this.content,
    required this.bannerUrl,
    required this.targetUrl,
    required this.placementType,
    required this.venues,
  });

  factory AdvertisementDetail.fromJson(Map<String, dynamic> json) {
    return AdvertisementDetail(
      advertisementId: json['advertisementId'],
      title: json['title'],
      content: json['content'],
      bannerUrl: json['bannerUrl'],
      targetUrl: json['targetUrl'],
      placementType: json['placementType'],
      venues: (json['venues'] as List)
          .map((venueJson) => VenueInAdvertisementDetail.fromJson(venueJson))
          .toList(),
    );
  }
}