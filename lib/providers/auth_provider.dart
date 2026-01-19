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
    await SessionStorage.clear();
    notifyListeners();
  }
}
