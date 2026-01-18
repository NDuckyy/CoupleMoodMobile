import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/api_service.dart';

class CoupleMapScreen extends StatefulWidget {
  final int? userId; // Đổi thành int để match backend
  
  const CoupleMapScreen({super.key, this.userId});

  @override
  State<CoupleMapScreen> createState() => _CoupleMapScreenState();
}

class _CoupleMapScreenState extends State<CoupleMapScreen> with SingleTickerProviderStateMixin {
  VietmapController? _mapController;
  LatLng? _currentLocation;
  bool _isLoading = true;
  final List<LatLng> _loveLocations = [];
  String _currentStyle = 'light';
  bool _showStyleSelector = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  // API & Firebase
  final ApiService _apiService = ApiService();
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  StreamSubscription<Position>? _locationStream;
  Map<int, LatLng> _watchlistLocations = {};
  List<int> _watchlistIds = [];
  String? _firebaseUid; // Firebase Anonymous UID

  final Map<String, Map<String, dynamic>> _mapStyles = {
    'light': {
      'name': '☀️ Light',
      'url': 'https://maps.vietmap.vn/api/maps/light/styles.json?apikey=38fe2ab25dfdd69f462e5f1e80351b0503ce15d6c5067648',
      'color': const Color(0xFFFFF9E6),
    },
    'streets': {
      'name': '🗺️ Streets',
      'url': 'https://maps.vietmap.vn/api/maps/streets/styles.json?apikey=38fe2ab25dfdd69f462e5f1e80351b0503ce15d6c5067648',
      'color': const Color(0xFFE8F5E9),
    },
    'dark': {
      'name': '🌙 Dark',
      'url': 'https://maps.vietmap.vn/api/maps/dark/styles.json?apikey=38fe2ab25dfdd69f462e5f1e80351b0503ce15d6c5067648',
      'color': const Color(0xFF2C2C3E),
    },
    'basic': {
      'name': '🎨 Pastel',
      'url': 'https://maps.vietmap.vn/api/maps/basic/styles.json?apikey=38fe2ab25dfdd69f462e5f1e80351b0503ce15d6c5067648',
      'color': const Color(0xFFE1F5FE),
    },
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _initialize();
  }

  Future<void> _initialize() async {
    print('🚀 [INIT] Starting initialization...');
    
    // 1. Firebase Anonymous Sign In
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      _firebaseUid = userCredential.user?.uid;
      print('🔥 [FIREBASE] Signed in anonymously: $_firebaseUid');
    } catch (e) {
      print('❌ [FIREBASE] Sign in error: $e');
    }

    // 2. Test backend connection
    print('🔌 [API] Testing backend connection...');
    bool connected = await _apiService.testConnection();
    if (connected) {
      print('✅ [API] Backend connected');
    } else {
      print('❌ [API] Backend NOT connected. Check baseUrl in api_service.dart');
    }

    // 3. Request location permission
    print('📍 [GPS] Requesting location permission...');
    await _requestPermissionAndGetLocation();
    
    // 4. Start uploading my location
    if (widget.userId != null && _firebaseUid != null) {
      print('📤 [GPS] Starting location tracking for userId: ${widget.userId}');
      _startLocationTracking();
    } else {
      print('⚠️ [GPS] Cannot start tracking: userId=${widget.userId}, firebaseUid=$_firebaseUid');
    }
    
    // 5. Load watchlist from backend
    print('📋 [API] Loading watchlist from backend...');
    await _loadWatchlistFromBackend();
    
    print('✅ [INIT] Initialization complete!');
  }

  Future<void> _loadWatchlistFromBackend() async {
    try {
      print('🚀 [API] Calling GET /LocationTracking/watchlist...');
      final watchlist = await _apiService.getWatchlist();
      
      print('📥 [API] Response: $watchlist');
      
      setState(() {
        _watchlistIds = watchlist;
      });
      
      if (watchlist.isEmpty) {
        print('⚠️ [WATCHLIST] Empty watchlist - no users to track');
      } else {
        print('✅ [WATCHLIST] Loaded ${watchlist.length} users: $watchlist');
        
        // Listen to each user's location from Firebase
        for (int userId in watchlist) {
          print('👂 [FIREBASE] Starting listener for user $userId');
          _listenToUserLocation(userId);
        }
      }
    } catch (e) {
      print('❌ [API] Load watchlist error: $e');
      print('💡 [TIP] Make sure you logged in and have valid JWT token');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _locationStream?.cancel(); // BƯỚC 2: Cleanup
    super.dispose();
  }

  Future<void> _requestPermissionAndGetLocation() async {
    final status = await Permission.location.request();
    
    if (status.isGranted) {
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _currentLocation = LatLng(21.028511, 105.804817);
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _currentLocation = LatLng(21.028511, 105.804817);
        _isLoading = false;
      });
    }
  }

  void _onMapCreated(VietmapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  void _addLoveLocation() async {
    if (_mapController != null) {
      final cameraPosition = _mapController!.cameraPosition;
      final center = cameraPosition!.target;
      
      setState(() {
        _loveLocations.add(center);
      });

      await _mapController!.addSymbol(
        SymbolOptions(
          geometry: center,
          textField: '💕',
          textSize: 30,
          textColor: const Color(0xFFFF69B4),
          textOffset: const Offset(0, -0.5),
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.favorite, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  '💝 Đã lưu kỷ niệm tình yêu!',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFFF69B4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
            elevation: 6,
          ),
        );
      }
    }
  }

  void _changeMapStyle(String styleKey) {
    setState(() {
      _currentStyle = styleKey;
      _showStyleSelector = false;
      _animationController.reverse();
    });
    
    if (_mapController != null) {
      _mapController!.setStyle(_mapStyles[styleKey]!['url']);
    }
  }

  void _goToCurrentLocation() async {
    if (_mapController != null && _currentLocation != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 15),
      );
    }
  }

  // BƯỚC 2: Thêm Firebase functions
  void _startLocationTracking() {
    if (widget.userId == null) return;
    
    _locationStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 20, // Cập nhật mỗi 20m
      ),
    ).listen((Position position) {
      _uploadLocation(position.latitude, position.longitude);
      
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    });
  }

  Future<void> _uploadLocation(double lat, double lng) async {
    if (widget.userId == null || _firebaseUid == null) return;
    
    try {
      // Upload to Firebase using Firebase UID as key
      await _db.child('locations/$_firebaseUid').set({
        'userId': widget.userId, // App user ID
        'lat': lat,
        'lng': lng,
        'timestamp': ServerValue.timestamp,
      });
      print('📤 [FIREBASE] Uploaded location: lat=$lat, lng=$lng, userId=${widget.userId}, firebaseUid=$_firebaseUid');
    } catch (e) {
      print('❌ [FIREBASE] Upload location error: $e');
    }
  }

  // Listen to a specific user's location from Firebase
  void _listenToUserLocation(int userId) {
    print('👂 [FIREBASE] Setting up listener for userId: $userId');
    
    // Listen to all Firebase UIDs and filter by userId
    _db.child('locations').onChildAdded.listen((event) {
      _processLocationUpdate(event, userId);
    });
    
    _db.child('locations').onChildChanged.listen((event) {
      _processLocationUpdate(event, userId);
    });
  }
  
  void _processLocationUpdate(DatabaseEvent event, int targetUserId) {
    if (event.snapshot.value != null && mounted) {
      try {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        final userIdFromFirebase = data['userId'] as int?;
        
        // Only process if this is the user we're tracking
        if (userIdFromFirebase == targetUserId) {
          final lat = data['lat'] as double;
          final lng = data['lng'] as double;
          final timestamp = data['timestamp'];
          
          print('📥 [FIREBASE] Received location for userId $targetUserId: lat=$lat, lng=$lng, timestamp=$timestamp');
          
          setState(() {
            _watchlistLocations[targetUserId] = LatLng(lat, lng);
          });

          // Add/update marker on map
          _updateMarkerForUser(targetUserId, LatLng(lat, lng));
        }
      } catch (e) {
        print('❌ [FIREBASE] Parse location error: $e');
      }
    }
  }

  // Update marker for a user
  Future<void> _updateMarkerForUser(int userId, LatLng position) async {
    if (_mapController == null) {
      print('⚠️ [MAP] Cannot update marker: map controller is null');
      return;
    }

    try {
      print('📍 [MAP] Adding marker for userId $userId at $position');
      
      await _mapController!.addSymbol(
        SymbolOptions(
          geometry: position,
          iconImage: 'marker-15', // Use built-in marker icon
          iconSize: 1.5,
        ),
      );
      
      print('✅ [MAP] Marker added successfully for userId $userId');
    } catch (e) {
      print('❌ [MAP] Update marker error: $e');
    }
  }

  // Add user to watchlist via backend
  Future<void> _addToWatchlist(int targetUserId) async {
    bool success = await _apiService.addToWatchlist(targetUserId);
    
    if (success && mounted) {
      setState(() {
        _watchlistIds.add(targetUserId);
      });
      
      // Start listening to this user's location
      _listenToUserLocation(targetUserId);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Đã thêm user $targetUserId vào watchlist'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Không thể thêm user $targetUserId'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Remove user from watchlist via backend
  Future<void> _removeFromWatchlist(int targetUserId) async {
    bool success = await _apiService.removeFromWatchlist(targetUserId);
    
    if (success && mounted) {
      setState(() {
        _watchlistIds.remove(targetUserId);
        _watchlistLocations.remove(targetUserId);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Đã xóa user $targetUserId khỏi watchlist'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // TEST: Add demo markers
  Future<void> _addDemoMarkers() async {
    if (_mapController == null) return;

    print('🎯 [TEST] Adding demo markers...');
    
    // Demo user locations (around current position)
    final demoUsers = [
      {'userId': 456, 'lat': (_currentLocation?.latitude ?? 10.762622) + 0.001, 'lng': (_currentLocation?.longitude ?? 106.660172) + 0.001},
      {'userId': 789, 'lat': (_currentLocation?.latitude ?? 10.762622) - 0.002, 'lng': (_currentLocation?.longitude ?? 106.660172) + 0.002},
      {'userId': 999, 'lat': (_currentLocation?.latitude ?? 10.762622) + 0.003, 'lng': (_currentLocation?.longitude ?? 106.660172) - 0.001},
    ];

    for (var user in demoUsers) {
      final userId = user['userId'] as int;
      final lat = user['lat'] as double;
      final lng = user['lng'] as double;
      
      await _updateMarkerForUser(userId, LatLng(lat, lng));
      print('✅ [TEST] Added demo marker for user $userId at ($lat, $lng)');
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Đã thêm 3 demo markers'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Bản đồ Vietmap
          _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(
                        color: Color(0xFFFFB6D9),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '💖 Đang tải bản đồ tình yêu... 💖',
                        style: TextStyle(
                          color: Color(0xFFFF99C8),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              : VietmapGL(
                  styleString: _mapStyles[_currentStyle]!['url'],
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation ?? LatLng(21.028511, 105.804817),
                    zoom: 14,
                  ),
                  trackCameraPosition: true,
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  myLocationTrackingMode: MyLocationTrackingMode.tracking,
                  compassEnabled: false,
                  attributionButtonPosition: AttributionButtonPosition.bottomLeft,
                  minMaxZoomPreference: const MinMaxZoomPreference(5, 20),
                ),

          // Header hiện đại với glassmorphism
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.8),
                        Colors.white.withOpacity(0.5),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFB6D9), Color(0xFFFF8DC7)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFFB6D9).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.favorite, color: Colors.white, size: 20),
                                SizedBox(width: 6),
                                Text(
                                  'Love Map',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.place_rounded,
                                  color: Color(0xFFFF69B4),
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${_loveLocations.length}',
                                  style: const TextStyle(
                                    color: Color(0xFFFF69B4),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Style Selector Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 70,
            left: 16,
            child: _buildGlassButton(
              icon: Icons.layers_outlined,
              onPressed: () {
                setState(() {
                  _showStyleSelector = !_showStyleSelector;
                  if (_showStyleSelector) {
                    _animationController.forward();
                  } else {
                    _animationController.reverse();
                  }
                });
              },
              color: const Color(0xFF9C6FDE),
            ),
          ),

          // Style Selector Panel
          if (_showStyleSelector)
            Positioned(
              top: MediaQuery.of(context).padding.top + 130,
              left: 16,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildStyleSelector(),
              ),
            ),

          // Nút chức năng bên phải - hiện đại hơn
          Positioned(
            right: 16,
            bottom: 120,
            child: Column(
              children: [
                _buildGlassButton(
                  icon: Icons.favorite,
                  onPressed: _addLoveLocation,
                  color: const Color(0xFFFF69B4),
                ),
                const SizedBox(height: 12),
                _buildGlassButton(
                  icon: Icons.my_location,
                  onPressed: _goToCurrentLocation,
                  color: const Color(0xFF7C9FE4),
                ),
              ],
            ),
          ),

    
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Test: Add demo markers
          FloatingActionButton(
            heroTag: 'demo_markers',
            onPressed: _addDemoMarkers,
            backgroundColor: Colors.purple,
            child: const Icon(Icons.people),
          ),
          const SizedBox(height: 10),
          // Test: Add to watchlist
          FloatingActionButton(
            heroTag: 'add_watchlist',
            onPressed: () async {
              print('🧪 [TEST] Calling addToWatchlist(456)...');
              await _addToWatchlist(456);
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.person_add),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(16),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStyleSelector() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _mapStyles.entries.map((entry) {
              final isSelected = _currentStyle == entry.key;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: isSelected
                      ? entry.value['color'].withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => _changeMapStyle(entry.key),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(
                                color: entry.value['color'],
                                width: 2,
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: entry.value['color'],
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              entry.value['name'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? entry.value['color']
                                    : Colors.grey[800],
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: entry.value['color'],
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildModernInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Gradient gradient,
  }) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
// End of _CoupleMapScreenState
