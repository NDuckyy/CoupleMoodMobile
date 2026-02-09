import 'package:couple_mood_mobile/models/recommendation/recommendation.dart';

class RecommendationResponse {
  final List<Recommendation> recommendations;
  final String? explanation;
  final String? coupleMoodType;
  final String? singleMood;
  final List<String>? personalityTags;

  RecommendationResponse({
    required this.recommendations,
    this.explanation,
    this.coupleMoodType,
    this.singleMood,
    this.personalityTags,
  });

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) {
    return RecommendationResponse(
      recommendations: (json['recommendations'] as List)
          .map((item) => Recommendation.fromJson(item))
          .toList(),
      explanation: json['explanation'] as String?,
      coupleMoodType: json['coupleMoodType'] as String?,
      singleMood: json['singleMood'] as String?,
      personalityTags: json['personalityTags'] != null
          ? List<String>.from(json['personalityTags'])
          : null,
    );
  }
}
