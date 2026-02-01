import 'package:couple_mood_mobile/models/recommendation/recommendation_response.dart';
import 'package:couple_mood_mobile/services/recommendation_service.dart';
import 'package:flutter/material.dart';

class RecommendationProvider extends ChangeNotifier {
  RecommendationResponse? _recommendationResponse;
  bool isLoading = false;
  String? error;
  RecommendationResponse? get recommendationResponse => _recommendationResponse;

  Future<void> fetchRecommendations() async {
    try {
      isLoading = true;
      notifyListeners();
  
      await Future.delayed(const Duration(seconds: 2));
      _recommendationResponse = await RecommendationService.fetchRecommendations();
      isLoading = false;
      notifyListeners();
      
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
    }
  }
}
