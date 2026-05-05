import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/couple/couple.dart';
import 'package:couple_mood_mobile/models/couple/couple_tag_description.dart';
import 'package:couple_mood_mobile/models/couple/update_couple_profile_request.dart';
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

  static Future<ApiResponse<void>> updateCoupleProfile(
    UpdateCoupleProfileRequest request,
  ) async {
    try {
      final res = await ApiClient.request(
        "/couple-profile",
        method: HttpMethod.put,
        data: request.toJson(),
      );
      return ApiResponse.fromJson(res, (data) {});
    } catch (e) {
      throw Exception('Lỗi khi cập nhật thông tin cặp đôi: $e');
    }
  }

  static Future<ApiResponse<void>> breakupCouple() async {
    try {
      final res = await ApiClient.request(
        "/couple-invitations/breakup",
        method: HttpMethod.post,
      );
      return ApiResponse.fromJson(res, (data) {});
    } catch (e) {
      throw Exception('Lỗi khi chia tay: $e');
    }
  }

  static Future<ApiResponse<List<CoupleTagDescription>>>
  getPersonalityDescriptions() async {
    try {
      final res = await ApiClient.request(
        "/VenueLocation/personality-types/all",
        method: HttpMethod.get,
      );
      return ApiResponse.fromJson(res, (data) {
        return (data as List).map((e) => CoupleTagDescription.fromJson(e)).toList();
      });
    } catch (e) {
      throw Exception('Lỗi khi lấy mô tả tính cách: $e');
    }
  }

  static Future<ApiResponse<List<CoupleTagDescription>>>
  getCoupleMoodDescriptions() async {
    try {
      final res = await ApiClient.request(
        "/VenueLocation/mood-types/all",
        method: HttpMethod.get,
      );
      return ApiResponse.fromJson(res, (data) {
        return (data as List).map((e) => CoupleTagDescription.fromJson(e)).toList();
      });
    } catch (e) {
      throw Exception('Lỗi khi lấy mô tả tâm trạng của cặp đôi: $e');
    }
  }
}
