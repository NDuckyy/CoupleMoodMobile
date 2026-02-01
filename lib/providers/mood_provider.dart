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

  MoodFace get currentMood => _currentMood;

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
}
