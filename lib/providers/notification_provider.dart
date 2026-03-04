import 'package:couple_mood_mobile/models/checkin/validate_condition.dart';
import 'package:couple_mood_mobile/services/review_service.dart';
import 'package:flutter/foundation.dart';

class NotificationProvider extends ChangeNotifier {
  bool isLoading = false;
  String? error;

  Future<bool> validateCheckIn(int checkInId, ValidateCondition condition) async {
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
}
