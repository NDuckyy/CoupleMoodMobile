import 'dart:convert';

import 'package:couple_mood_mobile/mock/recommendation_mock.dart';
import 'package:couple_mood_mobile/models/api_response.dart';
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
        "/Recommendation",
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
}
