import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/dateplan/date_plan_response.dart';
import 'package:couple_mood_mobile/services/date_plan_service.dart';
import 'package:flutter/material.dart';

class DatePlanProvider extends ChangeNotifier {
  ApiResponse<DatePlanPageResult>? datePlans;
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
}
