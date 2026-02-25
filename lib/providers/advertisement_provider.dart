import 'package:couple_mood_mobile/models/advertisement/advertisement.dart';
import 'package:couple_mood_mobile/services/advertisement_service.dart';
import 'package:flutter/material.dart';

class AdvertisementProvider extends ChangeNotifier {
  String? error;
  bool isLoading = true;
  List<Advertisement> advertisements = [];

  Future<void> fetchSpecialEvents() async {
    try {
      isLoading = true;
      notifyListeners();
      final response = await AdvertisementService().fetchAdvertisements();
      advertisements = response.data ?? [];
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
