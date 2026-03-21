class RecommendationRequest {
  final double? lat;
  final double? lng;
  final double? radiusKm;
  final String? area;
  final int? limit;
  final String? query;
  final int? page;
  final int? pageSize;

  RecommendationRequest({
    this.lat,
    this.lng,
    this.radiusKm,
    this.area,
    this.limit,
    this.query,
    this.page,
    this.pageSize,
  });

  Map<String, dynamic> toJson() {
    return {
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (radiusKm != null) 'radiusKm': radiusKm,
      if (area != null) 'area': area,
      if (limit != null) 'limit': limit,
      if (query != null) 'query': query,
      if (page != null) 'page': page,
      if (pageSize != null) 'pageSize': pageSize,
    };
  }
}
