import 'package:couple_mood_mobile/providers/couple_location_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CoupleLocationScreen extends StatefulWidget {
  const CoupleLocationScreen({super.key});

  @override
  State<CoupleLocationScreen> createState() =>
      _CoupleLocationScreenState();
}

class _CoupleLocationScreenState extends State<CoupleLocationScreen> {
  @override
  void initState() {
    super.initState();

    final provider =
        Provider.of<CoupleLocationProvider>(context, listen: false);

    provider.listenLocation("coupleId_123"); // 👈 start listen
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CoupleLocationProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Couple Map 💕")),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(10.8231, 106.6297),
          zoom: 14,
        ),
        markers: provider.markers,
        myLocationEnabled: true,
      ),
    );
  }
}