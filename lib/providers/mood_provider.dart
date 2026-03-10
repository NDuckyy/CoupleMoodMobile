import 'dart:io';

import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/mood/current_mood.dart';
import 'package:couple_mood_mobile/models/mood/mood_face.dart';
import 'package:couple_mood_mobile/models/mood/mood_type.dart';
import 'package:couple_mood_mobile/services/mood_service.dart';
import 'package:flutter/foundation.dart';

class MoodProvider extends ChangeNotifier {
  ApiResponse<List<MoodFace>>? _currentMoodResponse;
  CurrentMood? coupleCurrentMood;
  bool isLoading = false;
  String? error;
  ApiResponse<List<MoodType>> moodTypes = ApiResponse(
    message: '',
    code: 0,
    data: [],
  );
  String? _userCurrentMood = '';

  String? get userCurrentMood => _userCurrentMood;

  MoodFace? currentMoodCamera;

  Future<void> getCurrentMoodByCamera(File file) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      _currentMoodResponse = await MoodService.getCurrentMoodByCamera(file);

      if (_currentMoodResponse!.code != 200 ||
          _currentMoodResponse!.data == null ||
          _currentMoodResponse!.data!.isEmpty) {
        error = _currentMoodResponse!.message;
        currentMoodCamera = null;
      } else {
        currentMoodCamera = _currentMoodResponse!.data!.first;
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      currentMoodCamera = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getMoodTypes(String gender) async {
    try {
      isLoading = true;
      notifyListeners();
      moodTypes = await MoodService.getMoodTypes(gender);
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateMood(int moodTypeId) async {
    try {
      await MoodService.updateMood(moodTypeId);
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    }
  }

  Future<void> getCurrentMood() async {
    try {
      isLoading = true;
      notifyListeners();
      final moodResponse = await MoodService.getCurrentMood();
      if (moodResponse.code != 200 || moodResponse.data == null) {
        error = moodResponse.message;
        _userCurrentMood = null;
      } else {
        _userCurrentMood = moodResponse.data!.currentMood;
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCoupleCurrentMood() async {
    error = null;
    isLoading = true;
    notifyListeners();
    try {
      final moodResponse = await MoodService.getCurrentMood();
      if (moodResponse.code != 200 || moodResponse.data == null) {
        error = moodResponse.message;
        coupleCurrentMood = null;
      } else {
        coupleCurrentMood = moodResponse.data;
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
