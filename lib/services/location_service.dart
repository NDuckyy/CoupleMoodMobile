import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/dateplan/date_plan_item_response.dart';
import 'package:couple_mood_mobile/models/user/geo_response.dart';
import 'package:couple_mood_mobile/services/api_client.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'checkin_watcher.dart';

class LocationService {
  static bool _isListening = false;
  final dbRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        "https://couplemood-firebase-default-rtdb.asia-southeast1.firebasedatabase.app/",
  ).ref("locations");

  static Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Check GPS
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    // 2. Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    // 3. Get position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  static StreamSubscription<Position>? _positionSub;

  static Future<void> startListening(String coupleId, String userId) async {
    if (_isListening) return;
    _isListening = true;
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    _positionSub?.cancel();

    _positionSub =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 1, // update mỗi 1m
          ),
        ).listen((Position position) {
          print("USER MOVED: ${position.latitude}, ${position.longitude}");
          print("👉 BEFORE CHECKIN");
          CheckInWatcher.onLocationUpdate(
            position.latitude,
            position.longitude,
          );
          print("👉 BEFORE UPDATE LOCATION");
          LocationService.updateLocation(coupleId, userId, position);
          print("👉 AFTER UPDATE LOCATION");
        });
  }

  static Future<void> updateLocation(
    String coupleId,
    String userId,
    Position position,
  ) async {
    print("🔥 Updating location...");
    print("👉 coupleId: $coupleId");
    print("👉 userId: $userId");

    final dbRef = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          "https://couplemood-firebase-default-rtdb.asia-southeast1.firebasedatabase.app",
    ).ref("locations");

    try {
      await dbRef.child(coupleId).child("users").child(userId).update({
        "lat": position.latitude,
        "lng": position.longitude,
        "updatedAt": DateTime.now().millisecondsSinceEpoch,
      });

      print("✅ WRITE SUCCESS");
    } catch (e) {
      print("❌ WRITE ERROR: $e");
    }
  }

  static Future<void> updateVenues(
    String coupleId,
    String userId,
    List<ListDatePlanItem> venues,
  ) async {
    final ref = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          "https://couplemood-firebase-default-rtdb.asia-southeast1.firebasedatabase.app",
    ).ref("locations");

    await ref
        .child(coupleId)
        .child("venues")
        .set(
          venues
              .map(
                (e) => {
                  "id": e.id,
                  "name": e.venueLocation.name,
                  "lat": e.venueLocation.latitude,
                  "lng": e.venueLocation.longitude,
                },
              )
              .toList(),
        );
  }

  static Future<void> clearVenues(String coupleId) async {
    final ref = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          "https://couplemood-firebase-default-rtdb.asia-southeast1.firebasedatabase.app",
    ).ref("locations");

    await ref.child(coupleId).child("venues").remove();
  }

  static Future<void> stopListening() async {
    _positionSub?.cancel();
    _isListening = false;
  }

  static Future<void> updateUserPosition(
    int memberId,
    double lat,
    double lng,
  ) async {
    try {
      await ApiClient.request(
        "/geo/$memberId",
        method: HttpMethod.put,
        data: {"homeLatitude": lat, "homeLongitude": lng},
      );
    } catch (e) {
      debugPrint("❌ UPDATE USER POSITION ERROR: $e");
    }
  }

  static Future<ApiResponse<GeoResponse>> getPosition(int memberId) async {
    try {
      final res = await ApiClient.request(
        "/geo/$memberId",
        method: HttpMethod.get,
      );
      return ApiResponse.fromJson(res, (json) => GeoResponse.fromJson(json));
    } catch (e) {
      debugPrint("❌ GET USER POSITION ERROR: $e");
      throw Exception('Lỗi khi lấy vị trí người dùng: $e');
    }
  }
}
