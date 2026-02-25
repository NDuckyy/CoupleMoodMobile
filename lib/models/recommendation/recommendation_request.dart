class RecommendationRequest {
  final double? latitude;
  final double? longitude;
  final double? radiusKm;
  final String? area;
  final int? limit;

  RecommendationRequest({
    this.latitude,
    this.longitude,
    this.radiusKm,
    this.area,
    this.limit,
  });

  Map<String, dynamic> toJson() {
    return {
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (radiusKm != null) 'radiusKm': radiusKm,
      if (area != null) 'area': area,
      if (limit != null) 'limit': limit,
    };
  }
}
