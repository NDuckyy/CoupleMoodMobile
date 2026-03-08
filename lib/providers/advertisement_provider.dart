import 'package:couple_mood_mobile/models/advertisement/advertisement.dart';
import 'package:couple_mood_mobile/services/advertisement_service.dart';
import 'package:flutter/material.dart';

class AdvertisementProvider extends ChangeNotifier {
  String? error;
  bool isLoading = true;
  bool isLoadingSpecialEvent = true;
  bool isLoadingPopup = true;
  bool isLoadingAdvertisement = true;
  List<Advertisement> advertisements = [];
  List<Advertisement> specialEvents = [];
  Advertisement? popup;

  Future<void> fetchSpecialEvents() async {
    try {
      isLoadingSpecialEvent = true;
      notifyListeners();
      final response = await AdvertisementService().fetchAdvertisements(
        "SPECIAL_EVENT",
      );
      specialEvents = response.data ?? [];
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoadingSpecialEvent = false;
      notifyListeners();
    }
  }

  Future<void> fetchAdvertisementPopup() async {
    try {
      isLoadingPopup = true;
      notifyListeners();
      final response = await AdvertisementService().fetchAdvertisements(
        "POPUP",
      );
      final popups = response.data ?? [];
      if (popups.isNotEmpty) {
        popup = popups.first;
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoadingPopup = false;
      notifyListeners();
    }
  }

  Future<void> fetchAdvertisement() async {
    try {
      isLoadingAdvertisement = true;
      notifyListeners();
      final response = await AdvertisementService().fetchAdvertisements(null);
      advertisements = response.data ?? [];
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoadingAdvertisement = false;
      notifyListeners();
    }
  }
}
