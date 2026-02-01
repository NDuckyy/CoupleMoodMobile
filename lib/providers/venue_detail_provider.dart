import 'package:couple_mood_mobile/models/venue_model.dart';
import 'package:couple_mood_mobile/services/venue_service.dart';
import 'package:flutter/material.dart';

class VenueDetailProvider extends ChangeNotifier {
  Venue? venue;
  bool loading = false;

  Future<void> loadVenue(int id) async {
    loading = true;
    notifyListeners();

    venue = await VenueService.getVenueDetail(1);

    loading = false;
    notifyListeners();
  }
}
