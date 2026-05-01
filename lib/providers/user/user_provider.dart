import 'package:couple_mood_mobile/models/session.dart';
import 'package:couple_mood_mobile/models/subscription/member_subscription_package.dart';
import 'package:couple_mood_mobile/models/user/user_model.dart';
import 'package:couple_mood_mobile/services/user_service.dart';
import 'package:couple_mood_mobile/utils/session_storage.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel? user;
  bool isLoading = false;
  bool hasActiveSubscription = false;
  MemberActiveSubscription? subscription;
  String? error;

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
              balance: (user!.balance as num?)?.toInt(),
              points: (user!.points as num?)?.toInt(),
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

  void reset() {
    user = null;
    isLoading = false;
    notifyListeners();
  }

  Future<void> checkActiveSubscription() async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await UserService.getHasActiveSubscription();

      if (res.code == 200 && res.data != null) {
        subscription = res.data;

        hasActiveSubscription =
            (subscription?.packageId == 6 || subscription?.packageId == 7);

        print(
          "Subscription: packageId=${subscription?.packageId}, "
          "legacyActive=$hasActiveSubscription, "
          "beActive=${subscription?.hasActiveSubscription}",
        );
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
