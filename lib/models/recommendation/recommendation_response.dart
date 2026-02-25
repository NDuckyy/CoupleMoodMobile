import 'package:couple_mood_mobile/models/recommendation/recommendation_page.dart';

class RecommendationResponse {
  final RecommendationPage recommendations;
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
      recommendations: RecommendationPage.fromJson(json['recommendations']),
      explanation: json['explanation'] as String?,
      coupleMoodType: json['coupleMoodType'] as String?,
      singleMood: json['singleMood'] as String?,
      personalityTags: json['personalityTags'] != null
          ? List<String>.from(json['personalityTags'])
          : null,
    );
  }
}
