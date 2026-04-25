import 'dart:io';
import 'package:couple_mood_mobile/models/user/interest_model.dart';
import 'package:flutter/material.dart';
import '../../models/user/update_profile_request.dart';
import '../../models/user/user_model.dart';
import '../../services/user_service.dart';
import '../../utils/upload_util.dart';

class EditProfileProvider extends ChangeNotifier {
  bool isLoading = false;
  List<String>? animals;
  List<InterestModel>? interests;
  List<String>? jobTitles;

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
    String? jobTitle,
    String? educationLevel,
    int? height,
    int? weight,
    String? city,
    String? district,
    List<String>? favoritePets,
    bool? hasPet,
    bool? smoking,
    List<String>? interests,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      String? avatarUrl = user.avatarUrl;

      if (avatarFile != null) {
        final urls = await UploadUtil.mediaUpload([avatarFile]);
        if (urls.isNotEmpty) {
          avatarUrl = urls.first;
        }
      }

      final profile = user.memberProfile;

      final request = UpdateProfileRequest(
        fullName: fullName,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
        gender: gender,
        avatarUrl: avatarUrl ?? user.avatarUrl,
        bio: bio ?? profile?.bio,

        jobTitle: jobTitle ?? profile?.jobTitle,
        educationLevel: educationLevel ?? profile?.educationLevel,
        height: height ?? profile?.height,
        weight: weight ?? profile?.weight,
        city: city ?? profile?.city,
        district: district ?? profile?.district,

        homeLatitude: profile?.homeLatitude,
        homeLongitude: profile?.homeLongitude,

        budgetMin: budgetMin ?? profile?.budgetMin,
        budgetMax: budgetMax ?? profile?.budgetMax,

        favoritePets: favoritePets ?? profile?.favoritePets,
        hasPet: hasPet ?? profile?.hasPet,
        smoking: smoking ?? profile?.smoking,
        interests: interests ?? profile?.interests,
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

  Future<void> fetchAnimals() async {
    try {
      final res = await UserService.getAnimal();
      if (res.code == 200 && res.data != null) {
        animals = res.data;
        notifyListeners();
      }
    } catch (e) {
      print("Fetch animals error: $e");
    }
  }

  Future<void> fetchInterests() async {
    try {
      final res = await UserService.getInterests();
      if (res.code == 200 && res.data != null) {
        interests = res.data;
        notifyListeners();
      }
    } catch (e) {
      print("Fetch interests error: $e");
    }
  }

  Future<void> fetchJobTitles() async {
    try {
      final res = await UserService.getJobTitles();
      if (res.code == 200 && res.data != null) {
        jobTitles = res.data;
        notifyListeners();
      }
    } catch (e) {
      print("Fetch job titles error: $e");
    }
  }
}
