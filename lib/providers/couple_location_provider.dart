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

  Future<void> loadAvatars(String myAvatarUrl, String partnerAvatarUrl) async {
    myAvatar = await createAvatarMarker(
      myAvatarUrl.isNotEmpty
          ? myAvatarUrl
          : "https://cdn11.dienmaycholon.vn/filewebdmclnew/public/userupload/files/Image%20FP_2024/avatar-cute-2.jpg",
    );
    partnerAvatar = await createAvatarMarker(
      partnerAvatarUrl.isNotEmpty
          ? partnerAvatarUrl
          : "https://cdn11.dienmaycholon.vn/filewebdmclnew/public/userupload/files/Image%20FP_2024/avatar-cute-3.jpg",
    );
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

  Future<BitmapDescriptor> createAvatarMarker(
    String imageUrl, {
    int size = 140,
  }) async {
    final data = await NetworkAssetBundle(Uri.parse(imageUrl)).load("");
    final bytes = data.buffer.asUint8List();

    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final center = Offset(size / 2, size / 2);

    final outerRadius = size / 2;
    final innerRadius = size / 2.6;

    final borderPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(size.toDouble(), size.toDouble()),
        [Color(0xFFFDC5F5), Color(0xFFB388EB)],
      );
    canvas.drawCircle(center, outerRadius, borderPaint);

    final clipPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: innerRadius));

    canvas.save();
    canvas.clipPath(clipPath);

    final src = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );

    final dst = Rect.fromCircle(center: center, radius: innerRadius);

    canvas.drawImageRect(image, src, dst, Paint());
    canvas.restore();

    final picture = recorder.endRecording();
    final img = await picture.toImage(size, size);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

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
