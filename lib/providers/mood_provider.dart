import 'dart:io';

import 'package:couple_mood_mobile/models/mood/mood_face.dart';
import 'package:couple_mood_mobile/models/mood/mood_type.dart';
import 'package:couple_mood_mobile/services/mood_service.dart';
import 'package:flutter/foundation.dart';

class MoodProvider extends ChangeNotifier {
  MoodFace _currentMood = MoodFace(dominantEmotion: '', emotionSentence: '');
  bool isLoading = false;
  String? error;
  List<MoodType> moodTypes = [];
  String? _userCurrentMood = '';

  MoodFace get currentMood => _currentMood;
  String? get userCurrentMood => _userCurrentMood;

  Future<void> getCurrentMoodByCamera(File file) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      _currentMood = await MoodService.getCurrentMoodByCamera(file);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
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

  Future<void> getMoodTypeById(int id, String gender) async {
    try {
      isLoading = true;
      notifyListeners();
      final moodType = await MoodService.getMoodTypeById(id, gender);
      moodTypes = [moodType];
    } catch (e) {
      throw Exception('Lỗi khi lấy mood type: $e');
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
