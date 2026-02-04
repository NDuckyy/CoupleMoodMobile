class Recommendation {
  final int venueId;
  final String venueName;
  final int matchScore;
  final String aiReasoning;
  final String category;
  final String address;
  final double rating;
  final int reviewCount;
  final int estimatedBudget;
  final double latitude;
  final double longitude;
  final double distance;
  final String? imageUrl;

  Recommendation({
    required this.venueId,
    required this.venueName,
    required this.matchScore,
    required this.aiReasoning,
    required this.category,
    required this.address,
    required this.rating,
    required this.reviewCount,
    required this.estimatedBudget,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.imageUrl,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      venueId: json['venueId'],
      venueName: json['venueName'],
      matchScore: json['matchScore'],
      aiReasoning: json['aiReasoning'],
      category: json['category'],
      address: json['address'],
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'],
      estimatedBudget: json['estimatedBudget'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
