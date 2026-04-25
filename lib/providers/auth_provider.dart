import 'package:couple_mood_mobile/models/change_password_request.dart';
import 'package:couple_mood_mobile/models/register_request.dart';
import 'package:couple_mood_mobile/models/reset_password_request.dart';
import 'package:flutter/foundation.dart';
import '../models/session.dart';
import '../services/auth_service.dart';
import '../utils/session_storage.dart';

class AuthProvider extends ChangeNotifier {
  Session? session;
  bool isLoading = false;
  String? error;

  bool get isLoggedIn => session != null;

  Future<void> init() async {
    session = await SessionStorage.load();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      session = await AuthService.login(email, password);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    session = null;
    await AuthService.logout();
    notifyListeners();
  }

  Future<bool> register(RegisterRequest request) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final ok = await AuthService.register(request);
      isLoading = false;
      notifyListeners();
      return ok;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginWithGoogle(String idToken) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      session = await AuthService.loginWithGoogle(idToken);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final res = await AuthService.forgotPassword(email);
      if (res.code == 200) {
        return true;
      } else {
        error = res.message;
        return false;
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(ResetPasswordRequest request) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final res = await AuthService.resetPassword(request);
      if (res.code != 200) {
        error = res.message;
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changePassword(ChangePasswordRequest request) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final res = await AuthService.changePassword(request);
      if (res.code != 200) {
        error = res.message;
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
