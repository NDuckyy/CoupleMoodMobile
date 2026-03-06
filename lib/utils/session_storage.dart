import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/session.dart';

class SessionStorage {
  static const _secure = FlutterSecureStorage();

  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';
  static const _kProfile = 'user_profile';

  /// Decode JWT token to get payload
  static Map<String, dynamic>? _decodeJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return null;
      }

      final payload = parts[1];
      var normalized = base64Url.normalize(payload);
      var decoded = utf8.decode(base64Url.decode(normalized));
      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (e) {
      print('Error decoding JWT: $e');
      return null;
    }
  }

  static Future<void> save(Session s) async {
    await _secure.write(key: _kAccess, value: s.accessToken);
    if (s.refreshToken != null) {
      await _secure.write(key: _kRefresh, value: s.refreshToken);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kProfile, jsonEncode(s.profileToJson()));
  }

  static Future<Session?> load() async {
    final access = await _secure.read(key: _kAccess);
    if (access == null || access.isEmpty) {
      print('SessionStorage.load() - No access token found');
      return null;
    }

    final refresh = await _secure.read(key: _kRefresh);

    final prefs = await SharedPreferences.getInstance();
    final profileStr = prefs.getString(_kProfile);

    Map<String, dynamic>? profile;
    if (profileStr != null && profileStr.isNotEmpty) {
      profile = jsonDecode(profileStr) as Map<String, dynamic>;
      print('SessionStorage.load() - Profile loaded: $profile');
    } else {
      print('SessionStorage.load() - No profile found in SharedPreferences');
    }

    // Decode JWT to get userId if not in profile
    int? userId = profile?['userId'] as int?;
    if (userId == null) {
      final jwtPayload = _decodeJwt(access);
      if (jwtPayload != null && jwtPayload['sub'] != null) {
        userId = int.tryParse(jwtPayload['sub'].toString());
        print('SessionStorage.load() - userId from JWT: $userId');
      }
    }

    final session = Session.fromTokensAndProfile(
      accessToken: access,
      refreshToken: refresh,
      profile: profile,
      userIdFromToken: userId,
    );

    print('SessionStorage.load() - Session userId: ${session.userId}');
    return session;
  }

  static Future<void> clear() async {
    await _secure.delete(key: _kAccess);
    await _secure.delete(key: _kRefresh);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kProfile);
  }
}
