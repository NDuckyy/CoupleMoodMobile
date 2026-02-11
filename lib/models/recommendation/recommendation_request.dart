class RecommendationRequest {
  final double? latitude;
  final double? longitude;
  final double? radiusKm;
  final String? area;

  RecommendationRequest({
    this.latitude,
    this.longitude,
    this.radiusKm,
    this.area,
  });

  Map<String, dynamic> toJson() {
    return {
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (radiusKm != null) 'radiusKm': radiusKm,
      if (area != null) 'area': area,
    };
  }
}
