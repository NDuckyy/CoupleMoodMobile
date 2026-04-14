import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/checkin/checkin_session.dart';
import 'package:couple_mood_mobile/models/checkin/validate_condition.dart';
import 'package:couple_mood_mobile/services/api_client.dart';
import 'package:couple_mood_mobile/models/checkin/checkin_payload.dart';
import 'package:flutter/material.dart';

class ReviewService {
  static Future<void> triggerCheckIn(CheckInPayload payload) async {
    try {
      final res = await ApiClient.request(
        "/Review/check-in-trigger",
        method: HttpMethod.post,
        data: payload.toJson(),
      );

      if (res == null) {
        throw Exception("Không nhận được phản hồi từ server");
      }

      if (res["code"] != 200) {
        throw Exception(res["message"] ?? "Check-in thất bại");
      }

      final checkInId = res["data"];
      if (checkInId == null) {
        throw Exception("Không nhận được checkInId");
      }

      CheckInSession.checkInId = (checkInId as num).toInt();
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  static Future<ApiResponse<int>> validateCheckIn(
    int checkInId,
    ValidateCondition condition,
  ) async {
    try {
      final res = await ApiClient.request(
        "/Review/validate-condition",
        method: HttpMethod.post,
        query: {"checkInId": checkInId},
        data: condition.toJson(),
      );
      return ApiResponse.fromJson(res, (json) => json as int);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Lỗi khi xác thực check-in: $e');
    }
  }
}
