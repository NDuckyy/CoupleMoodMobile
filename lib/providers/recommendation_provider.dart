import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/recommendation/recommendation_request.dart';
import 'package:couple_mood_mobile/models/recommendation/recommendation_response.dart';
import 'package:couple_mood_mobile/services/recommendation_service.dart';
import 'package:flutter/material.dart';

class RecommendationProvider extends ChangeNotifier {
  int page = 1;
  final int pageSize = 10;
  bool isLoadingMore = false;

  double? latitude;
  double? longitude;
  ApiResponse<RecommendationResponse>? _recommendationResponse;
  bool isLoading = true;
  String? error;
  RecommendationResponse? get recommendationResponse =>
      _recommendationResponse?.data;

  Future<void> fetchRecommendations(RecommendationRequest request) async {
    page = 1;
    try {
      isLoading = true;
      notifyListeners();
      _recommendationResponse =
          await RecommendationService.fetchRecommendations(
            request,
            page,
            pageSize,
          );
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore) return;

    final current = recommendationResponse?.recommendations;
    if (current == null || current.hasNextPage != true) return;

    try {
      isLoadingMore = true;
      notifyListeners();

      final nextPage = page + 1;

      final response = await RecommendationService.fetchRecommendations(
        RecommendationRequest(
          latitude: latitude,
          longitude: longitude,
          radiusKm: 1000,
          area: "79",
        ),
        nextPage,
        pageSize,
      );

      final newData = response.data?.recommendations;
      if (newData == null) return;

      current.items.addAll(newData.items);

      current.hasNextPage = newData.hasNextPage;

      page = nextPage;
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }
}
