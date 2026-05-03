import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/recommendation/category.dart';
import 'package:couple_mood_mobile/models/recommendation/context.dart';
import 'package:couple_mood_mobile/models/recommendation/context_recommendation.dart';
import 'package:couple_mood_mobile/models/recommendation/recommendation_request.dart';
import 'package:couple_mood_mobile/models/recommendation/recommendation_response.dart';
import 'package:couple_mood_mobile/models/recommendation/search_history.dart';
import 'package:couple_mood_mobile/services/api_client.dart';
import 'package:flutter/material.dart';

class RecommendationService {
  static Future<ApiResponse<RecommendationResponse>> fetchRecommendations(
    RecommendationRequest request,
  ) async {
    try {
      final res = await ApiClient.request(
        "/venue-location/search",
        method: HttpMethod.post,
        data: request.toJson(),
      );
      return ApiResponse.fromJson(
        res,
        (json) => RecommendationResponse.fromJson(json),
      );
    } catch (e) {
      debugPrint(e.toString());
      print('Lỗi khi lấy gợi ý địa điểm: $e');
      throw Exception('Lỗi khi lấy gợi ý địa điểm: $e');
    }
  }

  static Future<ApiResponse<Context>> fetchContext() async {
    try {
      final res = await ApiClient.request(
        '/v1/user-context',
        method: HttpMethod.get,
      );
      return ApiResponse.fromJson(res, (json) => Context.fromJson(json));
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Lỗi khi lấy ngữ cảnh người dùng: $e');
    }
  }

  static Future<ContextRecommendation> fetchRecommendationsByContext() async {
    try {
      final context = await fetchContext();
      final res = await ApiClient.requestForContext(
        method: HttpMethod.post,
        data: {
          "q": context.data?.searchHistories ?? "",
          "filter": "isPenalty = false",
          "personalize": {"userContext": context.data?.userContext ?? ""},
        },
      );
      return ContextRecommendation.fromJson(res);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Lỗi khi tìm kiếm địa điểm: $e');
    }
  }

  static Future<List<dynamic>> autoComplete(String query) async {
    try {
      final res = await ApiClient.autoComplete(
        method: HttpMethod.post,
        data: {
          "q": query,
          "limit": 5,
          "attributesToHighlight": ["name"],
        },
      );
      return res['hits'] as List<dynamic>;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Lỗi khi tìm kiếm địa điểm: $e');
    }
  }

  static Future<ApiResponse<SearchHistory>> fetchSearchHistory() async {
    try {
      final res = await ApiClient.request(
        "/SearchHistory/my-history",
        method: HttpMethod.get,
        query: {"page": 1, "pageSize": 5},
      );
      return ApiResponse.fromJson(res, (json) => SearchHistory.fromJson(json));
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Lỗi khi lấy lịch sử tìm kiếm: $e');
    }
  }

  static Future<ApiResponse<CategoryPagination>> fetchCategory({required int page, required int pageSize}) async {
    try {
      final res = await ApiClient.request(
        "/Category",
        method: HttpMethod.get,
        query: {"page": page, "pageSize": pageSize},
      );
      return ApiResponse.fromJson(
        res,
        (json) => CategoryPagination.fromJson(json),
      );
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Lỗi khi lấy danh mục địa điểm: $e');
    }
  }
}
