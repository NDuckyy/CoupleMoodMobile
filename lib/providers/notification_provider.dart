import 'package:couple_mood_mobile/models/checkin/validate_condition.dart';
import 'package:couple_mood_mobile/models/notification/notification.dart';
import 'package:couple_mood_mobile/services/notification_service.dart';
import 'package:couple_mood_mobile/services/review_service.dart';
import 'package:flutter/foundation.dart';

class NotificationProvider extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  NotificationPagination? notifications;

  Future<bool> validateCheckIn(
    int checkInId,
    ValidateCondition condition,
  ) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final res = await ReviewService.validateCheckIn(checkInId, condition);
      if (res.code != 200) {
        error = res.message;
        notifyListeners();
        return false;
      } else {
        return true;
      }
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> getNotifications(
    int pageNumber,
    int pageSize,
    String type,
  ) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final response = await NotificationService.getNotification(
        pageNumber,
        pageSize,
        type,
      );
      notifications = response.data;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
