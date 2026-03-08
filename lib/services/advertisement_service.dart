import 'package:couple_mood_mobile/models/advertisement/advertisement.dart';
import 'package:couple_mood_mobile/models/advertisement/advertisement_detail.dart';
import 'package:couple_mood_mobile/models/advertisement/special_event_detail.dart';
import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/services/api_client.dart';
import 'package:flutter/material.dart';

class AdvertisementService {
  Future<ApiResponse<List<Advertisement>>> fetchAdvertisements(String? placementType) async {
    try {
      final res = await ApiClient.request(
        "/Advertisement",
        query: {"placementType": placementType},
        method: HttpMethod.get,
      );
      return ApiResponse<List<Advertisement>>.fromJson(
        res,
        (json) => Advertisement.listFromJson(json as List<dynamic>),
      );
    } catch (e) {
      throw Exception('Lỗi khi lấy quảng cáo: $e');
    }
  }

  Future<ApiResponse<AdvertisementDetail>> fetchAdvertisementDetail(int advertisementId) async {
    try {
      final res = await ApiClient.request(
        "/Advertisement/detail/$advertisementId",
        query: {"type": "ADVERTISEMENT"},
        method: HttpMethod.get,
      );
      return ApiResponse<AdvertisementDetail>.fromJson(
        res,
        (json) => AdvertisementDetail.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      debugPrint('Lỗi khi lấy chi tiết quảng cáo: $e');
      throw Exception('Lỗi khi lấy chi tiết quảng cáo: $e');
    }
  }

  Future<ApiResponse<SpecialEventDetail>> fetchSpecialEventDetail(int advertisementId) async {
    try {
      final res = await ApiClient.request(
        "/Advertisement/detail/$advertisementId",
        query: {"type": "SPECIAL_EVENT"},
        method: HttpMethod.get,
      );
      return ApiResponse<SpecialEventDetail>.fromJson(
        res,
        (json) => SpecialEventDetail.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      debugPrint('Lỗi khi lấy chi tiết sự kiện đặc biệt: $e');
      throw Exception('Lỗi khi lấy chi tiết sự kiện đặc biệt: $e');
    }
  }
}
