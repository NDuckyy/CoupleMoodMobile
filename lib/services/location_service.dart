import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
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
  
  static Future<void> startListening() async {
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
          LocationService.updateLocation("31", "10", position);
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
      await dbRef.child(coupleId).child(userId).set({
        "lat": position.latitude,
        "lng": position.longitude,
        "updatedAt": DateTime.now().millisecondsSinceEpoch,
      });

      print("✅ WRITE SUCCESS");
    } catch (e) {
      print("❌ WRITE ERROR: $e");
    }
  }
}
