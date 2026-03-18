import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CoupleLocationProvider extends ChangeNotifier {
  final _dbRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        "https://couplemood-firebase-default-rtdb.asia-southeast1.firebasedatabase.app",
  ).ref("locations");

  Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  void listenLocation(String coupleId) {
    _dbRef.child(coupleId).onValue.listen((event) {
      final data = event.snapshot.value as Map?;

      if (data == null) return;

      Set<Marker> newMarkers = {};

      data.forEach((userId, value) {
        final lat = value["lat"];
        final lng = value["lng"];

        newMarkers.add(
          Marker(
            markerId: MarkerId(userId),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: userId),
          ),
        );
      });

      _markers = newMarkers;
      notifyListeners();
    });
  }
}
