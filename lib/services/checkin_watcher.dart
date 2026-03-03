import 'dart:math';
import 'package:couple_mood_mobile/services/review_service.dart';
import 'package:couple_mood_mobile/services/checkin_session.dart';
import 'package:couple_mood_mobile/models/checkin_payload.dart';

class CheckInWatcher {

  // ================= TEST MODE =================
  static const bool testMode = false;

  static const double testLat = 11.067127598476832;
  static const double testLng = 106.82377520853868;
  static const int testVenueId = 164;
  // =============================================

  static bool _alreadyTriggered = false;

  static Future<void> onLocationUpdate(double userLat, double userLng) async {

    if (_alreadyTriggered) return;

    // 👉 nếu test mode → giả lập user đang ở venue
    final double currentLat = testMode ? testLat : userLat;
    final double currentLng = testMode ? testLng : userLng;

    final distance = _calculateDistance(
      currentLat,
      currentLng,
      testLat,
      testLng,
    );

    print("Distance to venue: $distance");

    if (distance <= 100) {

      final payload = CheckInPayload(
        venueLocationId: testVenueId,
        latitude: testLat,
        longitude: testLng,
      );

      await ReviewService.triggerCheckIn(payload);

      CheckInSession.lastCheckIn = payload;

      _alreadyTriggered = true;

      print("AUTO CHECK-IN TRIGGERED ✅");
    }
  }

  static double _calculateDistance(
      double lat1, double lon1,
      double lat2, double lon2,
      ) {

    const R = 6371000;

    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);

    final a =
        sin(dLat/2) * sin(dLat/2) +
            cos(_toRad(lat1)) *
                cos(_toRad(lat2)) *
                sin(dLon/2) *
                sin(dLon/2);

    final c = 2 * atan2(sqrt(a), sqrt(1-a));

    return R * c;
  }

  static double _toRad(double deg) => deg * pi / 180;
}