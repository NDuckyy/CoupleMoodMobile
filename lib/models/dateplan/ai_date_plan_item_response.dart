class AiDatePlanItemResponse {
  final String? reason;
  final List<VenueItem> items;

  AiDatePlanItemResponse({required this.items, this.reason});

  factory AiDatePlanItemResponse.fromJson(Map<String, dynamic> json) {
    return AiDatePlanItemResponse(
      reason: json['reason'],
      items: (json['items'] as List<dynamic>)
          .map((e) => VenueItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class VenueItem {
  final int venueLocationId;
  final String? venueName;
  final String? venueDescription;
  final String? venueAddress;
  final double? venueAverageRating;
  final List<String>? venueCoverImage;
  final String startTime;
  final String endTime;
  final String note;

  VenueItem({
    required this.venueLocationId,
    this.venueName,
    this.venueDescription,
    this.venueAddress,
    this.venueAverageRating,
    this.venueCoverImage,
    required this.startTime,
    required this.endTime,
    required this.note,
  });

  factory VenueItem.fromJson(Map<String, dynamic> json) {
    return VenueItem(
      venueLocationId: json['venueLocationId'],
      venueName: json['venueName'],
      venueDescription: json['venueDescription'],
      venueAddress: json['venueAddress'],
      venueAverageRating: (json['venueAverageRating'] as num?)?.toDouble(),
      venueCoverImage: (json['venueCoverImage'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      startTime: json['startTime'],
      endTime: json['endTime'],
      note: json['note'],
    );
  }
}
