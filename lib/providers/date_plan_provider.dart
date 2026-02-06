import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/dateplan/date_plan_create_request.dart';
import 'package:couple_mood_mobile/models/dateplan/date_plan_item_response.dart';
import 'package:couple_mood_mobile/models/dateplan/date_plan_response.dart';
import 'package:couple_mood_mobile/services/date_plan_service.dart';
import 'package:flutter/material.dart';

class DatePlanProvider extends ChangeNotifier {
  ApiResponse<DatePlanPageResult>? datePlans;
  ApiResponse<DatePlanItemResponse>? datePlanItems;
  bool isLoading = false;
  String? error;

  int pageNumber = 1;
  final int pageSize = 5;

  Future<void> fetchDatePlans({int? page}) async {
    error = null;
    if (isLoading) return;
    isLoading = true;
    notifyListeners();
    try {
      pageNumber = page ?? pageNumber;
      datePlans = await DatePlanService.getDatePlans(
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      if (datePlans?.code != 200) {
        error = datePlans?.message ?? 'Lỗi khi lấy danh sách kế hoạch hẹn hò';
      }
      isLoading = false;
    } catch (e) {
      debugPrint(e.toString());
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void nextPage() {
    if (datePlans?.data?.pagedResult.hasNextPage == true) {
      fetchDatePlans(page: pageNumber + 1);
    }
  }

  void previousPage() {
    if (datePlans?.data?.pagedResult.hasPreviousPage == true) {
      fetchDatePlans(page: pageNumber - 1);
    }
  }

  Future<void> createDatePlan(DatePlanCreateRequest request) async {
    error = null;
    isLoading = true;
    notifyListeners();
    try {
      final response = await DatePlanService.createDatePlan(request);
      if (response.code != 200) {
        error = response.message;
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDatePlanItems(int datePlanId) async {
    error = null;
    if (isLoading) return;
    isLoading = true;
    notifyListeners();
    try {
      datePlanItems = await DatePlanService.getDatePlanItems(datePlanId);
      debugPrint('Fetched date plan items: $datePlanItems');
      if (datePlanItems?.code != 200) {
        error = datePlanItems?.message ?? 'Lỗi khi lấy danh sách mục kế hoạch hẹn hò';
      }
      isLoading = false;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
