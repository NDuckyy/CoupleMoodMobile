import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/recommendation/category.dart';
import 'package:couple_mood_mobile/models/recommendation/context_recommendation.dart';
import 'package:couple_mood_mobile/models/recommendation/recommendation_request.dart';
import 'package:couple_mood_mobile/models/recommendation/recommendation_response.dart';
import 'package:couple_mood_mobile/models/recommendation/search_history.dart';
import 'package:couple_mood_mobile/services/recommendation_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RecommendationProvider extends ChangeNotifier {
  int page = 1;
  final int pageSize = 10;
  bool isLoadingMore = false;
  bool isRefreshing = false;
  double? latitude;
  double? longitude;
  ApiResponse<RecommendationResponse>? _recommendationResponse;
  ApiResponse<RecommendationResponse>? _homeRecommendationResponse;
  ContextRecommendation? _contextRecommendationResponse;
  List<dynamic> autoCompleteResult = [];
  List<SearchHistoryItem> searchHistory = [];
  bool isLoading = true;
  bool isContextLoading = true;
  bool isAutoCompleteLoading = false;
  bool isSearchHistoryLoading = false;

  List<CategoryItem> allCategories = [];
  List<CategoryItem> filteredCategories = [];
  String categoryKeyword = "";
  bool isCategoryLoading = false;
  CategoryItem? selectedCategory;

  RangeValues priceRange = const RangeValues(0, 1000000);

  String? error;
  RecommendationResponse? get recommendationResponse =>
      _recommendationResponse?.data;

  RecommendationResponse? get homeRecommendationResponse =>
      _homeRecommendationResponse?.data;

  ContextRecommendation? get contextRecommendationResponse =>
      _contextRecommendationResponse;

  Future<void> fetchRecommendations(RecommendationRequest request) async {
    page = 1;
    error = null;
    if (recommendationResponse == null) {
      isLoading = true;
    } else {
      isRefreshing = true;
    }
    notifyListeners();
    try {
      _recommendationResponse =
          await RecommendationService.fetchRecommendations(request);
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      isRefreshing = false;
      notifyListeners();
    } finally {
      isLoading = false;
      isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> fetchRecommendationsContext(
    RecommendationRequest request,
  ) async {
    page = 1;
    error = null;
    if (contextRecommendationResponse == null) {
      isContextLoading = true;
    } else {
      isRefreshing = true;
    }
    notifyListeners();
    try {
      final res = await RecommendationService.fetchRecommendations(request);
      if (res.data != null) {
        _contextRecommendationResponse ??= ContextRecommendation(hits: []);
        _contextRecommendationResponse!.hits = res.data?.recommendations.items ?? [];
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      isContextLoading = false;
      isRefreshing = false;
      notifyListeners();
    } finally {
      isContextLoading = false;
      isRefreshing = false;
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
          lat: latitude,
          lng: longitude,
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
      error = null;
      notifyListeners();
      _homeRecommendationResponse =
          await RecommendationService.fetchRecommendations(
            RecommendationRequest(
              lat: latitude,
              lng: longitude,
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
    error = null;
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

  Future<void> searchLocationsContext(String query) async {
    debugPrint('Searching locations with query: $query');
    page = 1;
    error = null;
    try {
      isRefreshing = true;
      notifyListeners();
      final res = await RecommendationService.fetchRecommendations(
        RecommendationRequest(query: query),
      );
      if (res.data != null) {
        _contextRecommendationResponse ??= ContextRecommendation(hits: []);
        _contextRecommendationResponse!.hits = res.data?.recommendations.items ?? [];
      }

      notifyListeners();
    } catch (e) {
      isRefreshing = false;
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    } finally {
      isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> fetchLocationsByContext() async {
    page = 1;
    error = null;
    if (contextRecommendationResponse == null) {
      isContextLoading = true;
    } else {
      isRefreshing = true;
    }
    try {
      notifyListeners();
      _contextRecommendationResponse =
          await RecommendationService.fetchRecommendationsByContext();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      isContextLoading = false;
      isRefreshing = false;
      notifyListeners();
    } finally {
      isContextLoading = false;
      isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> autoComplete(String query) async {
    isAutoCompleteLoading = true;
    notifyListeners();

    try {
      error = null;
      autoCompleteResult = await RecommendationService.autoComplete(query);
    } catch (e) {
      debugPrint('Auto-complete error: $e');
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isAutoCompleteLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSearchHistory() async {
    try {
      error = null;
      isSearchHistoryLoading = true;
      notifyListeners();
      final res = await RecommendationService.fetchSearchHistory();
      if (res.code == 200) {
        searchHistory = res.data?.items ?? [];
      } else {
        error = 'Lỗi khi lấy lịch sử tìm kiếm';
      }

      isSearchHistoryLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      isSearchHistoryLoading = false;
      notifyListeners();
    }
  }

  // Category

  Future<void> fetchAllCategories() async {
    if (allCategories.isNotEmpty) return;
    error = null;
    try {
      isCategoryLoading = true;
      notifyListeners();

      int page = 1;
      const pageSize = 20;
      bool hasNext = true;

      List<CategoryItem> temp = [];

      while (hasNext) {
        final res = await RecommendationService.fetchCategory(
          page: page,
          pageSize: pageSize,
        );

        if (res.code == 200) {
          final data = res.data;
          if (data != null) {
            temp.addAll(data.items);
            hasNext = data.hasNextPage;
            page++;
          } else {
            hasNext = false;
          }
        } else {
          throw Exception("Lỗi load category");
        }
      }

      temp.sort((a, b) => a.name.compareTo(b.name));

      allCategories = temp;
      filteredCategories = temp;
    } catch (e) {
      error = e.toString();
    } finally {
      isCategoryLoading = false;
      notifyListeners();
    }
  }

  void searchCategory(String keyword) {
    categoryKeyword = keyword;
    if (keyword.isEmpty) {
      filteredCategories = allCategories;
    } else {
      filteredCategories = allCategories.where((c) {
        return c.name.toLowerCase().contains(keyword.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }

  void selectCategory(CategoryItem category) {
    if (selectedCategory?.id == category.id) {
      selectedCategory = null;
    } else {
      selectedCategory = category;
    }

    notifyListeners();
  }

  void updatePrice(RangeValues values) {
    priceRange = values;
    notifyListeners();
  }
}
