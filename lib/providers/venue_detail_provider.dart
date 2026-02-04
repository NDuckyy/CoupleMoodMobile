import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/venue_model.dart';
import 'package:couple_mood_mobile/services/venue_service.dart';
import 'package:flutter/material.dart';

class VenueDetailProvider extends ChangeNotifier {
  ApiResponse<Venue>? venueResponse;
  bool loading = false;
  String? error;

  Venue? get venue => venueResponse?.data;

  Future<void> loadVenue() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      //hardcode test, nhớ remove huhu
      venueResponse = await VenueService.getVenueDetail(1);

      if (venueResponse!.code != 200 || venueResponse!.data == null) {
        error = venueResponse!.message;
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
