import 'package:couple_mood_mobile/models/recommendation/recommendation.dart';

class ContextRecommendation {
  List<Recommendation> hits;

  ContextRecommendation({required this.hits});

  factory ContextRecommendation.fromJson(Map<String, dynamic> json) {
    var hitsJson = json['hits'] as List;
    List<Recommendation> hitsList =
        hitsJson.map((hit) => Recommendation.fromJson(hit)).toList();
    return ContextRecommendation(hits: hitsList);
  }
}