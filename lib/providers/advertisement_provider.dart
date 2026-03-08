import 'package:couple_mood_mobile/models/advertisement/advertisement.dart';
import 'package:couple_mood_mobile/models/advertisement/advertisement_detail.dart';
import 'package:couple_mood_mobile/models/advertisement/special_event_detail.dart';
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
  AdvertisementDetail? advertisementDetail;
  SpecialEventDetail? specialEventDetail;

  Future<void> fetchSpecialEvents() async {
    try {
      isLoadingSpecialEvent = true;
      error = null;
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
      error = null;
      notifyListeners();
      final response = await AdvertisementService().fetchAdvertisements(
        "POPUP",
      );
      if (response.code != 200) {
        error = response.message;
        return;
      }
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
      error = null;
      notifyListeners();
      final response = await AdvertisementService().fetchAdvertisements(null);
      if (response.code != 200) {
        error = response.message;
        return;
      }
      advertisements = response.data ?? [];
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoadingAdvertisement = false;
      notifyListeners();
    }
  }

  Future<void> fetchAdvertisementDetail(int advertisementId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      final response = await AdvertisementService().fetchAdvertisementDetail(
        advertisementId,
      );
      if (response.code != 200) {
        error = response.message;
        return;
      }
      advertisementDetail = response.data;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSpecialEventDetail(int advertisementId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      final response = await AdvertisementService().fetchSpecialEventDetail(
        advertisementId,
      );
      if (response.code != 200) {
        error = response.message;
        return;
      }
      specialEventDetail = response.data;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
