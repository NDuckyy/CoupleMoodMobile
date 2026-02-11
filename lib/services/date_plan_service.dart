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

  static Future<ApiResponse<int>> createDatePlan(
    DatePlanCreateAndUpdateRequest request,
  ) async {
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

  static Future<ApiResponse<DatePlanItemResponse>> getDatePlanItems(
    int datePlanId,
  ) async {
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

  static Future<ApiResponse<DatePlanDetails>> getDatePlanDetails(
    int datePlanId,
  ) async {
    try {
      final res = await ApiClient.request(
        '/DatePlan/$datePlanId',
        method: HttpMethod.get,
      );
      return ApiResponse<DatePlanDetails>.fromJson(
        res,
        (json) => DatePlanDetails.fromJson(json),
      );
    } catch (e) {
      throw Exception('Lỗi khi lấy chi tiết kế hoạch hẹn hò: $e');
    }
  }

  static Future<ApiResponse<void>> updateDatePlan(
    int datePlanId,
    DatePlanCreateAndUpdateRequest request,
  ) async {
    try {
      final res = await ApiClient.request(
        '/DatePlan/$datePlanId?version=${request.version}',
        method: HttpMethod.patch,
        data: request.toJson(),
      );
      return ApiResponse<void>.fromJson(res, (_) {});
    } catch (e) {
      throw Exception('Lỗi khi cập nhật kế hoạch hẹn hò: $e');
    }
  }

  static Future<ApiResponse<void>> deleteDatePlan(int datePlanId) async {
    try {
      final res = await ApiClient.request(
        '/DatePlan/$datePlanId',
        method: HttpMethod.delete,
      );
      return ApiResponse<void>.fromJson(res, (_) {});
    } catch (e) {
      throw Exception('Lỗi khi xóa kế hoạch hẹn hò: $e');
    }
  }

  static Future<ApiResponse<void>> deleteDatePlanItem(
    int datePlanId,
    int datePlanItemId,
  ) async {
    try {
      final res = await ApiClient.request(
        '/DatePlan/$datePlanId/items/$datePlanItemId',
        method: HttpMethod.delete,
      );
      return ApiResponse<void>.fromJson(res, (_) {});
    } catch (e) {
      throw Exception('Lỗi khi xóa mục kế hoạch hẹn hò: $e');
    }
  }
}
