import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service để gọi API Backend
class ApiService {
  // ⚠️ QUAN TRỌNG: Thay đổi theo môi trường của bạn
  static const String baseUrl = 'http://localhost:5224/api'; // Android Emulator
  // static const String baseUrl = 'http://localhost:5224/api'; // iOS Simulator
  // static const String baseUrl = 'http://192.168.1.100:5224/api'; // Real Device (thay IP máy bạn)
  // static const String baseUrl = 'https://api.couplemood.com/api'; // Production

  // Lấy JWT token từ SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // Lưu token sau khi login
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  // Login và lưu token
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['data']['accessToken'];
        await saveToken(token);
        return true;
      }
      return false;
    } catch (e) {
      print('❌ Login error: $e');
      return false;
    }
  }

  // Lấy watchlist từ backend
  Future<List<int>> getWatchlist() async {
    try {
      final token = await _getToken();
      if (token == null) {
        print('⚠️ [API] No token found. Please login first.');
        return [];
      }

      print('🚀 [API] GET $baseUrl/LocationTracking/watchlist');
      print('🔑 [API] Token: ${token.substring(0, 20)}...');
      
      final response = await http.get(
        Uri.parse('$baseUrl/LocationTracking/watchlist'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('📥 [API] Response status: ${response.statusCode}');
      print('📥 [API] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List items = data['data'] ?? [];
        final userIds = items.map((item) => item['userId'] as int).toList();
        print('✅ [API] Watchlist retrieved: $userIds');
        return userIds;
      } else if (response.statusCode == 401) {
        print('❌ [API] 401 Unauthorized - Token expired. Please login again.');
      } else {
        print('❌ [API] Error ${response.statusCode}: ${response.body}');
      }
      return [];
    } catch (e) {
      print('❌ [API] Get watchlist exception: $e');
      return [];
    }
  }

  // Thêm vào watchlist
  Future<bool> addToWatchlist(int targetUserId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        print('⚠️ [API] No token found');
        return false;
      }

      print('🚀 [API] POST $baseUrl/LocationTracking/watchlist/add');
      print('📤 [API] Body: {"targetUserId": $targetUserId}');
      
      final response = await http.post(
        Uri.parse('$baseUrl/LocationTracking/watchlist/add'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'targetUserId': targetUserId}),
      );

      print('📥 [API] Response status: ${response.statusCode}');
      print('📥 [API] Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ [API] User $targetUserId added to watchlist');
        return true;
      } else {
        print('❌ [API] Failed to add user: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ [API] Add to watchlist exception: $e');
      return false;
    }
  }

  // Xóa khỏi watchlist
  Future<bool> removeFromWatchlist(int targetUserId) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.post(
        Uri.parse('$baseUrl/LocationTracking/watchlist/remove'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'targetUserId': targetUserId}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Remove from watchlist error: $e');
      return false;
    }
  }

  // Lấy thông tin user hiện tại
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrl/Users/me'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      }
      return null;
    } catch (e) {
      print('❌ Get current user error: $e');
      return null;
    }
  }

  // Test connection với backend
  Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Health'),
      ).timeout(const Duration(seconds: 5));

      print('🔗 Backend response: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Connection error: $e');
      print('💡 Tip: Kiểm tra backend có chạy không? $baseUrl');
      return false;
    }
  }
}
