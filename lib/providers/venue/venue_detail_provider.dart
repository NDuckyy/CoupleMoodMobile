import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/venue_model.dart';
import 'package:couple_mood_mobile/services/venue_service.dart';
import 'package:flutter/material.dart';

class VenueDetailProvider extends ChangeNotifier {
  ApiResponse<Venue>? venueResponse;
  bool loading = false;
  String? error;

  bool isFavorite = false;
  int favoriteCount = 0;

  Venue? get venue => venueResponse?.data;

  Future<void> loadVenue(int id) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      // TODO remove hardcode
      venueResponse = await VenueService.getVenueDetail(1);

      if (venueResponse!.code != 200 || venueResponse!.data == null) {
        error = venueResponse!.message;
      } else {
        favoriteCount = venue!.favoriteCount;
        isFavorite = false; // backend chưa có thì default
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
    favoriteCount += isFavorite ? 1 : -1;
    notifyListeners();

    // TODO call API
    // nếu fail => rollback
  }
}
