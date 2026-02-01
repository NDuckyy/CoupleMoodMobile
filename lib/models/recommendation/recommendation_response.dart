import 'package:couple_mood_mobile/models/recommendation/applied_filter.dart';
import 'package:couple_mood_mobile/models/recommendation/recommendation.dart';

class RecommendationResponse {
  final List<Recommendation> recommendations;
  final int totalResults;
  final int processingTimeMs;
  final double aiConfidence;
  final AppliedFilters appliedFilters;

  RecommendationResponse({
    required this.recommendations,
    required this.totalResults,
    required this.processingTimeMs,
    required this.aiConfidence,
    required this.appliedFilters,
  });

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) {
    return RecommendationResponse(
      recommendations: (json['recommendations'] as List)
          .map((e) => Recommendation.fromJson(e))
          .toList(),
      totalResults: json['totalResults'],
      processingTimeMs: json['processingTimeMs'],
      aiConfidence: (json['aiConfidence'] as num).toDouble(),
      appliedFilters: AppliedFilters.fromJson(json['appliedFilters']),
    );
  }
}
