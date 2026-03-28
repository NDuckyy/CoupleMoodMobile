import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/user/update_profile_request.dart';
import '../../models/user/user_model.dart';
import '../../services/user_service.dart';
import '../../utils/upload_util.dart';

class EditProfileProvider extends ChangeNotifier {
  bool isLoading = false;

  Future<bool> updateProfile({
    required UserModel user,
    required String fullName,
    required String phoneNumber,
    required String gender,
    required String dateOfBirth,
    String? bio,
    double? budgetMin,
    double? budgetMax,
    File? avatarFile,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      String? avatarUrl = user.avatarUrl;

      /// upload avatar nếu có
      if (avatarFile != null) {
        final urls = await UploadUtil.mediaUpload([avatarFile]);
        if (urls.isNotEmpty) {
          avatarUrl = urls.first;
        }
      }

      final request = UpdateProfileRequest(
        fullName: fullName,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
        gender: gender,
        avatarUrl: avatarUrl,
        bio: bio,
        homeLatitude: user.memberProfile?.homeLatitude,
        homeLongitude: user.memberProfile?.homeLongitude,
        budgetMin: budgetMin,
        budgetMax: budgetMax,
      );

      final res = await UserService.updateProfile(request);

      if (res.code == 200) {
        return true;
      } else {
        throw res.message ?? "Cập nhật thất bại";
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
