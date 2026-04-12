import 'package:couple_mood_mobile/models/couple/couple.dart';
import 'package:couple_mood_mobile/models/couple/update_couple_profile_request.dart';
import 'package:couple_mood_mobile/services/couple_service.dart';
import 'package:flutter/material.dart';

class CoupleProvider extends ChangeNotifier {
  Couple? couple;
  String? error;
  bool isLoading = true;

  Future<void> fetchCoupleProfile() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      final response = await CoupleService.fetchCoupleProfile();
      if (response.code != 200) {
        error = response.message;
      } else {
        couple = response.data;
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCoupleProfile(UpdateCoupleProfileRequest request) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      final response = await CoupleService.updateCoupleProfile(request);
      if (response.code != 200) {
        error = response.message;
      } else {
        await fetchCoupleProfile();
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      debugPrint("Lỗi nè: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> breakupCouple() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      final response = await CoupleService.breakupCouple();
      if (response.code != 200) {
        error = response.message;
      } else {
        couple = null;
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
