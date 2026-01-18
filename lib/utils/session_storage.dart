import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/session.dart';

class SessionStorage {
  static const _secure = FlutterSecureStorage();

  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';
  static const _kProfile = 'user_profile';

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
    if (access == null || access.isEmpty) return null;

    final refresh = await _secure.read(key: _kRefresh);

    final prefs = await SharedPreferences.getInstance();
    final profileStr = prefs.getString(_kProfile);

    Map<String, dynamic>? profile;
    if (profileStr != null && profileStr.isNotEmpty) {
      profile = jsonDecode(profileStr) as Map<String, dynamic>;
    }

    return Session.fromTokensAndProfile(
      accessToken: access,
      refreshToken: refresh,
      profile: profile,
    );
  }

  static Future<void> clear() async {
    await _secure.delete(key: _kAccess);
    await _secure.delete(key: _kRefresh);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kProfile);
  }
}
