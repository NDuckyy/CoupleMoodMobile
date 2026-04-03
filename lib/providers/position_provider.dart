
import 'package:couple_mood_mobile/services/location_service.dart';
import 'package:flutter/foundation.dart';

class PositionProvider extends ChangeNotifier {
  double? latitude;
  double? longitude;

  void getCurrentPosition() async {
    try {
      final position = await LocationService.getCurrentPosition();
      if (position != null) {
        latitude = position.latitude;
        longitude = position.longitude;
        debugPrint('User location: $latitude, $longitude');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }
}