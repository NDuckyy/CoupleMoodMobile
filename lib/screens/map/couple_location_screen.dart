import 'package:couple_mood_mobile/providers/couple_location_provider.dart';
import 'package:couple_mood_mobile/providers/mood_provider.dart';
import 'package:couple_mood_mobile/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CoupleLocationScreen extends StatefulWidget {
  const CoupleLocationScreen({super.key});

  @override
  State<CoupleLocationScreen> createState() => _CoupleLocationScreenState();
}

class _CoupleLocationScreenState extends State<CoupleLocationScreen> {
  Position? _initialPosition;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final pos = await LocationService.getCurrentPosition();

      final provider = Provider.of<CoupleLocationProvider>(
        context,
        listen: false,
      );

      final moodProvider = Provider.of<MoodProvider>(context, listen: false);

      await provider.loadAvatars();
      await Geolocator.requestPermission();
      provider.listenLocation(
        moodProvider.coupleCurrentMood?.coupleProfileId.toString() ??
            "unknown_couple",
        moodProvider.coupleCurrentMood?.memberId.toString() ?? "unknown_user",
      );
      LocationService.startListening(
        moodProvider.coupleCurrentMood!.coupleProfileId.toString(),
        moodProvider.coupleCurrentMood!.memberId.toString(),
      );

      if (pos != null && _mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(LatLng(pos.latitude, pos.longitude)),
        );
      }

      setState(() {
        _initialPosition = pos;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CoupleLocationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Vị trí cặp đôi"),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(
                _initialPosition?.latitude ?? 10.762622,
                _initialPosition?.longitude ?? 106.660172,
              ),
              zoom: 14,
            ),
            markers: provider.markers,
            myLocationEnabled: true,
          ),

          Positioned(
            bottom: 100,
            left: 16,
            child: FloatingActionButton(
              backgroundColor: Color(0xFF8093F1),
              heroTag: "me",
              onPressed: () {
                final pos = provider.myPosition;
                if (pos != null && _mapController != null) {
                  _mapController!.animateCamera(
                    CameraUpdate.newLatLngZoom(pos, 16),
                  );
                }
              },
              child: const Icon(Icons.my_location, color: Colors.white),
            ),
          ),

          Positioned(
            bottom: 40,
            left: 16,
            child: FloatingActionButton(
              heroTag: "partner",
              backgroundColor: Color(0xFFF7AEF8),
              onPressed: () {
                final pos = provider.partnerPosition;
                if (pos != null && _mapController != null) {
                  _mapController!.animateCamera(
                    CameraUpdate.newLatLngZoom(pos, 16),
                  );
                }
              },
              child: const Icon(Icons.favorite, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
