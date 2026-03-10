import 'package:couple_mood_mobile/models/session.dart';
import 'package:couple_mood_mobile/models/user/user_model.dart';
import 'package:couple_mood_mobile/services/user_service.dart';
import 'package:couple_mood_mobile/utils/session_storage.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel? user;
  bool isLoading = false;

  Future<void> fetchMe() async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await UserService.getMe();

      if (res.code == 200 && res.data != null) {
        user = res.data;

        /// update cached profile
        final session = await SessionStorage.load();

        if (session != null) {
          await SessionStorage.save(
            Session(
              accessToken: session.accessToken,
              refreshToken: session.refreshToken,
              userId: user!.id,
              avatarUrl: user!.avatarUrl,
              fullName: user!.fullName,
              gender: user!.memberProfile?.gender,
              dateOfBirth: user!.memberProfile?.dateOfBirth,
              inviteCode: user!.memberProfile?.inviteCode,
            ),
          );
        }
      }
    } catch (e) {
      print("Fetch user error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
