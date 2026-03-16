import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/couple/couple.dart';
import 'package:couple_mood_mobile/services/api_client.dart';
import 'package:flutter/material.dart';

class CoupleService {
  static Future<ApiResponse<Couple>> fetchCoupleProfile() async {
    try {
      final res = await ApiClient.request(
        "/couple-profile",
        method: HttpMethod.get,
      );
      return ApiResponse.fromJson(res, (data) => Couple.fromJson(data));
    } catch (e) {
      debugPrint("Error fetching couple profile: $e");
      rethrow;
    }
  }
}
