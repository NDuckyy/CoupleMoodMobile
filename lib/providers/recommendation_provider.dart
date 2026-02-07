import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/recommendation/recommendation_request.dart';
import 'package:couple_mood_mobile/models/recommendation/recommendation_response.dart';
import 'package:couple_mood_mobile/services/recommendation_service.dart';
import 'package:flutter/material.dart';

class RecommendationProvider extends ChangeNotifier {
  ApiResponse<RecommendationResponse>? _recommendationResponse;
  bool isLoading = false;
  String? error;
  RecommendationResponse? get recommendationResponse =>
      _recommendationResponse?.data;

  Future<void> fetchRecommendations(RecommendationRequest request) async {
    try {
      isLoading = true;
      notifyListeners();
      _recommendationResponse =
          await RecommendationService.fetchRecommendations(request);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
    }
  }
}
