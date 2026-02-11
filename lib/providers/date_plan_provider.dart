import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/dateplan/date_plan_create_request.dart';
import 'package:couple_mood_mobile/models/dateplan/date_plan_item_response.dart';
import 'package:couple_mood_mobile/models/dateplan/date_plan_response.dart';
import 'package:couple_mood_mobile/services/date_plan_service.dart';
import 'package:flutter/material.dart';

class DatePlanProvider extends ChangeNotifier {
  ApiResponse<DatePlanPageResult>? datePlans;
  ApiResponse<DatePlanItemResponse>? datePlanItems;
  ApiResponse<DatePlanDetails>? selectedDatePlan;
  bool isLoading = true;
  String? error;

  int pageNumber = 1;
  final int pageSize = 5;

  Future<void> fetchDatePlans({int? page}) async {
    error = null;
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

  Future<void> createDatePlan(DatePlanCreateAndUpdateRequest request) async {
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
    isLoading = true;
    notifyListeners();
    try {
      datePlanItems = await DatePlanService.getDatePlanItems(datePlanId);
      if (datePlanItems?.code != 200) {
        error =
            datePlanItems?.message ??
            'Lỗi khi lấy danh sách mục kế hoạch hẹn hò';
      }
      isLoading = false;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getDatePlanDetails(int datePlanId) async {
    error = null;
    if (isLoading) return;
    isLoading = true;
    notifyListeners();
    try {
      selectedDatePlan = await DatePlanService.getDatePlanDetails(datePlanId);
      if (selectedDatePlan?.code != 200) {
        error = selectedDatePlan?.message;
      }
      isLoading = false;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateDatePlan({
    required int id,
    required DatePlanCreateAndUpdateRequest request,
  }) async {
    error = null;
    isLoading = true;
    notifyListeners();
    try {
      final response = await DatePlanService.updateDatePlan(id, request);
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

  Future<void> deleteDatePlan(int datePlanId) async {
    error = null;
    isLoading = true;
    notifyListeners();
    try {
      final response = await DatePlanService.deleteDatePlan(datePlanId);
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

  Future<void> deleteDatePlanItem(int datePlanId, int datePlanItemId) async {
    error = null;
    isLoading = true;
    notifyListeners();
    try {
      final response = await DatePlanService.deleteDatePlanItem(datePlanId, datePlanItemId);
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
}
