import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/dateplan/date_plan_create_request.dart';
import 'package:couple_mood_mobile/models/dateplan/date_plan_item_response.dart';
import 'package:couple_mood_mobile/models/dateplan/date_plan_response.dart';
import 'package:couple_mood_mobile/services/api_client.dart';
import 'package:flutter/material.dart';

class DatePlanService {
  static Future<ApiResponse<DatePlanPageResult>> getDatePlans({
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      final res = await ApiClient.request(
        '/DatePlan?pageNumber=$pageNumber&pageSize=$pageSize',
        method: HttpMethod.get,
      );
      return ApiResponse<DatePlanPageResult>.fromJson(
        res,
        (json) => DatePlanPageResult.fromJson(json),
      );
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách kế hoạch hẹn hò: $e');
    }
  }

  static Future<ApiResponse<int>> createDatePlan(DatePlanCreateRequest request) async {
    try {
      final res = await ApiClient.request(
        '/DatePlan',
        method: HttpMethod.post,
        data: request.toJson(),
      );
      return ApiResponse<int>.fromJson(res, (json) => json as int);
    } catch (e) {
      throw Exception('Lỗi khi tạo kế hoạch hẹn hò: $e');
    }
  }

  static Future<ApiResponse<DatePlanItemResponse>> getDatePlanItems(int datePlanId) async {
    try {
      final res = await ApiClient.request(
        '/DatePlan/$datePlanId/items',
        method: HttpMethod.get,
      );
      return ApiResponse<DatePlanItemResponse>.fromJson(
        res,
        (json) => DatePlanItemResponse.fromJson(json),
      );
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Lỗi khi lấy danh sách mục kế hoạch hẹn hò: $e');
    }
  }
}
