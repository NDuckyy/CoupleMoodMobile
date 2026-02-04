import 'dart:io';

import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/mood/mood_face.dart';
import 'package:couple_mood_mobile/models/mood/mood_type.dart';
import 'package:couple_mood_mobile/services/mood_service.dart';
import 'package:flutter/foundation.dart';

class MoodProvider extends ChangeNotifier {
  ApiResponse<List<MoodFace>>? _currentMoodResponse;
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
      throw Exception('Lỗi khi lấy danh sách mood type: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateMood(int moodTypeId) async {
    try {
      await MoodService.updateMood(moodTypeId);
    } catch (e) {
      throw Exception('Lỗi khi cập nhật mood: $e');
    }
  }

  Future<void> getCurrentMood() async {
    try {
      isLoading = true;
      notifyListeners();
      _userCurrentMood = await MoodService.getCurrentMood();
    } catch (e) {
      throw Exception('Lỗi khi lấy mood hiện tại: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
