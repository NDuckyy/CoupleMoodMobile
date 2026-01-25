import 'dart:io';

import 'package:couple_mood_mobile/models/mood_type.dart';
import 'package:couple_mood_mobile/services/mood_service.dart';
import 'package:flutter/foundation.dart';

class MoodProvider extends ChangeNotifier {
  String _currentMood = 'neutral';
  bool isLoading = false;
  String? error;
  List<MoodType> moodTypes = [];

  String get currentMood => _currentMood;

  Future<String> getCurrentMoodByCamera(File file) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      _currentMood = await MoodService.getCurrentMoodByCamera(file);
      isLoading = false;
      notifyListeners();
      return _currentMood;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
      return '';
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
}
