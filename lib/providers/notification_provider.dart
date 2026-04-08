import 'package:couple_mood_mobile/models/checkin/validate_condition.dart';
import 'package:couple_mood_mobile/models/notification/notification.dart';
import 'package:couple_mood_mobile/services/notification_service.dart';
import 'package:couple_mood_mobile/services/review_service.dart';
import 'package:flutter/foundation.dart';

class NotificationProvider extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  NotificationPagination? notifications;
  int currentPage = 1;
  bool isLoadingMore = false;

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

  Future<void> loadMoreNotifications(String type) async {
    if (notifications == null ||
        notifications!.pageNumber >= notifications!.totalPages) {
      return;
    }
    isLoadingMore = true;
    error = null;
    notifyListeners();
    try {
      final nextPage = notifications!.pageNumber + 1;
      final response = await NotificationService.getNotification(
        nextPage,
        10,
        type,
      );
      if (response.code == 200 && response.data != null) {
        notifications!.items.addAll(response.data!.items);
        notifications!.pageNumber = response.data!.pageNumber;
      } else {
        error = response.message;
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      await NotificationService.markAsRead(notificationId);
      final index = notifications?.items.indexWhere(
        (notification) => notification.id == notificationId,
      );
      if (index != null && index >= 0) {
        notifications!.items[index].isRead = true;
        notifyListeners();
      }
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }
}
