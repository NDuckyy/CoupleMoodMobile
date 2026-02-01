import 'dart:convert';

import 'package:couple_mood_mobile/mock/recommendation_mock.dart';
import 'package:couple_mood_mobile/models/recommendation/recommendation_response.dart';

class RecommendationService {
  static Future<RecommendationResponse> fetchRecommendations() async {
    await Future.delayed(const Duration(seconds: 2));
    final decoded = jsonDecode(mockRecommendationJson);
    return RecommendationResponse.fromJson(decoded['data']);
  }
}
