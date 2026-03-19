import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/recommendation/context_recommendation.dart';
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
  ContextRecommendation? _contextRecommendationResponse;
  List<dynamic> autoCompleteResult = [];
  bool isLoading = true;
  bool isContextLoading = true;
  bool isAutoCompleteLoading = false;
  String? error;
  RecommendationResponse? get recommendationResponse =>
      _recommendationResponse?.data;

  ContextRecommendation? get contextRecommendationResponse =>
      _contextRecommendationResponse;

  Future<void> fetchRecommendations(RecommendationRequest request) async {
    page = 1;
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
          page: nextPage,
          pageSize: pageSize,
        ),
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

  Future<void> popularNearby() async {
    try {
      isLoading = true;
      notifyListeners();
      _recommendationResponse =
          await RecommendationService.fetchRecommendations(
            RecommendationRequest(
              latitude: latitude,
              longitude: longitude,
              page: page,
              pageSize: pageSize,
            ),
          );
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchLocations(String query) async {
    debugPrint('Searching locations with query: $query');
    page = 1;
    try {
      isLoading = true;
      notifyListeners();
      _recommendationResponse =
          await RecommendationService.fetchRecommendations(
            RecommendationRequest(query: query),
          );
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLocationsByContext() async {
    page = 1;
    try {
      isContextLoading = true;
      _contextRecommendationResponse = null;
      notifyListeners();
      _contextRecommendationResponse =
          await RecommendationService.fetchRecommendationsByContext();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      isContextLoading = false;
      notifyListeners();
    } finally {
      isContextLoading = false;
      notifyListeners();
    }
  }

  Future<void> autoComplete(String query) async {
    isAutoCompleteLoading = true;
    notifyListeners();

    try {
      autoCompleteResult = await RecommendationService.autoComplete(query);
    } catch (e) {
      debugPrint('Auto-complete error: $e');
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isAutoCompleteLoading = false;
      notifyListeners();
    }
  }
}
