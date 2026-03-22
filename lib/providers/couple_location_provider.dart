import 'dart:async';

import 'package:couple_mood_mobile/providers/mood_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class CoupleLocationProvider extends ChangeNotifier {
  final _dbRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        "https://couplemood-firebase-default-rtdb.asia-southeast1.firebasedatabase.app",
  ).ref("locations");

  MoodProvider? moodProvider;
  LatLng? myPosition;
  LatLng? partnerPosition;
  BitmapDescriptor? myAvatar;
  BitmapDescriptor? partnerAvatar;
  StreamSubscription? _locationSub;
  Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;
      
  Map<String, LatLng> _lastPositions = {};

  LatLng _lerp(LatLng a, LatLng b, double t) {
    return LatLng(
      a.latitude + (b.latitude - a.latitude) * t,
      a.longitude + (b.longitude - a.longitude) * t,
    );
  }

  Future<void> loadAvatars() async {
    myAvatar = await getAvatarMarker("./lib/assets/images/nam_vui.png");
    partnerAvatar = await getAvatarMarker("./lib/assets/images/nu_vui.png");
  }

  void listenLocation(String coupleId, String currentUserId) {
    _locationSub?.cancel();
    print("Listening to location changes for coupleId: $coupleId");
    print("Current User ID: $currentUserId");
    _locationSub = _dbRef.child(coupleId).onValue.listen((event) {
      final data = event.snapshot.value as Map?;

      if (data == null) return;

      Set<Marker> newMarkers = {};

      data.forEach((userId, value) async {
        final lat = value["lat"];
        final lng = value["lng"];

        final isMe = userId == currentUserId;
        final position = LatLng(lat, lng);
        if (isMe) {
          myPosition = position;
        } else {
          partnerPosition = position;
        }

        await _animateMarker(userId, LatLng(lat, lng), isMe);
      });

      _markers = newMarkers;
      notifyListeners();
    });
  }

  Future<BitmapDescriptor> getAvatarMarker(
    String assetPath, {
    int size = 120,
  }) async {
    final ByteData data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: size,
    );
    final frame = await codec.getNextFrame();

    final byteData = await frame.image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  Future<void> _animateMarker(
    String userId,
    LatLng newPosition,
    bool isMe,
  ) async {
    final oldPosition = _lastPositions[userId];

    if (oldPosition == null) {
      _lastPositions[userId] = newPosition;
      return;
    }

    const steps = 20; // càng cao càng mượt
    const duration = Duration(milliseconds: 500);

    for (int i = 1; i <= steps; i++) {
      final t = i / steps;

      final interpolated = _lerp(oldPosition, newPosition, t);

      _markers.removeWhere((m) => m.markerId.value == userId);

      _markers.add(
        Marker(
          markerId: MarkerId(userId),
          position: interpolated,
          icon: isMe
              ? (myAvatar ?? BitmapDescriptor.defaultMarker)
              : (partnerAvatar ?? BitmapDescriptor.defaultMarker),
          infoWindow: InfoWindow(title: isMe ? "You 📍" : "Your Partner ❤️"),
        ),
      );

      notifyListeners();
      await Future.delayed(duration ~/ steps);
    }

    _lastPositions[userId] = newPosition;
  }

  void reset() {
    _locationSub?.cancel();
    myPosition = null;
    partnerPosition = null;
    _markers.clear();
    _lastPositions.clear();
    notifyListeners();
  }
}
