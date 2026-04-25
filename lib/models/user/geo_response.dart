class GeoResponse {
  final double? homeLatitude;
  final double? homeLongitude;

  GeoResponse({this.homeLatitude, this.homeLongitude});

  factory GeoResponse.fromJson(Map<String, dynamic> json) {
    return GeoResponse(
      homeLatitude: (json['homeLatitude'] as num?)?.toDouble(),
      homeLongitude: (json['homeLongitude'] as num?)?.toDouble(),
    );
  }
}
