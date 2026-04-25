import 'package:couple_mood_mobile/models/report/report_target_type.dart';
import 'package:couple_mood_mobile/models/report/report_type.dart';
import 'package:couple_mood_mobile/services/report/report_service.dart';
import 'package:flutter/material.dart';

class ReportProvider extends ChangeNotifier {
  List<ReportType> reportTypes = [];

  bool loading = false;
  bool submitting = false;

  String? error;
  String? message;

  /// cache load 1 lần
  Future<void> loadReportTypes() async {
    if (reportTypes.isNotEmpty) return;

    try {
      loading = true;
      error = null;
      notifyListeners();

      final res = await ReportService.getReportTypes();

      if (res.code != 200) {
        error = res.message;
        return;
      }

      reportTypes = res.data?.items ?? [];
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> submitReport({
    required int reportTypeId,
    required ReportTargetType targetType,
    required int targetId,
    String? reason,
  }) async {
    try {
      submitting = true;
      error = null;
      message = null;
      notifyListeners();

      final res = await ReportService.createReport(
        reportTypeId: reportTypeId,
        targetType: targetType,
        targetId: targetId,
        reason: reason,
      );

      final success = res.code != null && res.code! >= 200 && res.code! < 300;

      if (success) {
        message = res.message;
        return true;
      } else {
        error = res.message ?? "Có lỗi xảy ra";
        return false;
      }
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      submitting = false;
      notifyListeners();
    }
  }
}
