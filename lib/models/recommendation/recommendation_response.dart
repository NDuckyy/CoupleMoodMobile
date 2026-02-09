import 'package:couple_mood_mobile/models/recommendation/recommendation.dart';

class RecommendationResponse {
  final List<Recommendation> recommendations;
  final String explanation;
  final String coupleMoodType;
  final String? singleMood;
  final List<String> personalityTags;

  RecommendationResponse({
    required this.recommendations,
    required this.explanation,
    required this.coupleMoodType,
    this.singleMood,
    required this.personalityTags,
  });

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) {
    return RecommendationResponse(
      recommendations: (json['recommendations'] as List)
          .map((item) => Recommendation.fromJson(item))
          .toList(),
      explanation: json['explanation'],
      coupleMoodType: json['coupleMoodType'],
      singleMood: json['singleMood'] as String?,
      personalityTags: List<String>.from(json['personalityTags']),
    );
  }
}
