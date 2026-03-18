import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/recommendation/context_recommendation.dart';
import 'package:couple_mood_mobile/models/recommendation/recommendation_request.dart';
import 'package:couple_mood_mobile/models/recommendation/recommendation_response.dart';
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
      throw Exception('Lỗi khi lấy gợi ý địa điểm: $e');
    }
  }

  static Future<ApiResponse<String>> fetchContext() async{
    try{
      final res = await ApiClient.request('/v1/user-context', method: HttpMethod.get);
      return ApiResponse.fromJson(res, (json) => json as String);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Lỗi khi lấy ngữ cảnh người dùng: $e');
    }
}

  static Future<ContextRecommendation>
  fetchRecommendationsByContext() async {
    try {
      final context = await fetchContext();
      final res = await ApiClient.requestForContext(
        method: HttpMethod.post,
        data: {
          "personalize": {"userContext": context.data},
        },
      );
      return ContextRecommendation.fromJson(res);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Lỗi khi tìm kiếm địa điểm: $e');
    }
  }
}
