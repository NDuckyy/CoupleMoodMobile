import 'package:couple_mood_mobile/providers/couple_location_provider.dart';
import 'package:couple_mood_mobile/providers/date_plan_provider.dart';
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
  VoidCallback? _datePlanListener;
  String? _lastVenueHash;

  late CoupleLocationProvider _provider;
  late DatePlanProvider _datePlanProvider;
  late MoodProvider _moodProvider;

  void _onCoupleChanged() {
    final coupleId = _moodProvider.coupleCurrentMood?.coupleProfileId;
    final memberId = _moodProvider.coupleCurrentMood?.memberId;

    print("🔄 Couple changed: $coupleId");

    // luôn stop trước
    LocationService.stopListening();
    _provider.disposeListener();
    _provider.reset();

    if (coupleId == null || memberId == null) {
      print("❌ Không có couple → stop");
      return;
    }

    // 🔥 start lại
    _provider.listenLocation(coupleId.toString(), memberId.toString());
    LocationService.startListening(coupleId.toString(), memberId.toString());
  }

  @override
  void initState() {
    super.initState();

    // 🔥 LẤY provider 1 lần (tránh dùng context trong dispose)
    _provider = context.read<CoupleLocationProvider>();
    _datePlanProvider = context.read<DatePlanProvider>();
    _moodProvider = context.read<MoodProvider>();

    _init();
    _moodProvider.addListener(_onCoupleChanged);
  }

  Future<void> _init() async {
    final pos = await LocationService.getCurrentPosition();

    if (!mounted) return;

    await _provider.loadAvatars(
      _moodProvider.myAvatarUrl ?? "",
      _moodProvider.partnerAvatarUrl ?? "",
    );

    await Geolocator.requestPermission();

    final coupleId = _moodProvider.coupleCurrentMood?.coupleProfileId;

    final memberId = _moodProvider.coupleCurrentMood?.memberId;

    // 🔥 START LISTEN
    if (coupleId == null || memberId == null) {
      print("❌ Không start location vì thiếu coupleId hoặc memberId");
      return;
    }
    _provider.listenLocation(coupleId.toString(), memberId.toString());
    LocationService.startListening(coupleId.toString(), memberId.toString());

    // 🔥 LISTENER DATE PLAN
    _datePlanListener = () {
      if (!mounted) return;

      final items = _datePlanProvider.datePlanItems;

      if (items != null && items.data != null && items.data!.items.isNotEmpty) {
        final currentHash = items.data!.items
            .map((e) => "${e.id}-${e.orderIndex}")
            .join(",");

        if (_lastVenueHash != currentHash) {
          _lastVenueHash = currentHash;

          LocationService.updateVenues(
            coupleId.toString(),
            memberId.toString(),
            items.data!.items,
          );
        }
      } else {
        LocationService.clearVenues(coupleId.toString());
      }
    };

    _datePlanProvider.addListener(_datePlanListener!);

    // 🔥 MOVE CAMERA SAFE
    if (pos != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(LatLng(pos.latitude, pos.longitude)),
      );
    }

    if (!mounted) return;

    setState(() {
      _initialPosition = pos;
    });
  }

  @override
  void dispose() {
    // 🔥 STOP ALL trước khi widget chết
    LocationService.stopListening();
    _provider.disposeListener(); // 👈 phải có trong provider
    _moodProvider.removeListener(_onCoupleChanged); 

    if (_datePlanListener != null) {
      _datePlanProvider.removeListener(_datePlanListener!);
    }

    _mapController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CoupleLocationProvider>();

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

          /// 🔥 MY LOCATION
          Positioned(
            bottom: 100,
            left: 16,
            child: FloatingActionButton(
              heroTag: "my_location_btn", // ❌ FIX duplicate key
              backgroundColor: const Color(0xFF8093F1),
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

          /// 🔥 PARTNER LOCATION
          Positioned(
            bottom: 40,
            left: 16,
            child: FloatingActionButton(
              heroTag: "partner_location_btn", // ❌ FIX duplicate key
              backgroundColor: const Color(0xFFF7AEF8),
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
