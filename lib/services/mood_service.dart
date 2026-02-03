import 'dart:io';

import 'package:couple_mood_mobile/models/mood/mood_face.dart';
import 'package:couple_mood_mobile/models/mood/mood_type.dart';
import 'package:couple_mood_mobile/services/api_client.dart';
import 'package:dio/dio.dart';

class MoodService {
  static Future<MoodFace> getCurrentMoodByCamera(File file) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });
    try {
      final res = await ApiClient.upload(
        '/Emotion/analyze',
        method: HttpMethod.post,
        data: formData,
      );
      final root = (res as Map).cast<String, dynamic>();
      final List<dynamic> data = (root['data'] as List).cast<dynamic>();

      return data.isNotEmpty
          ? MoodFace.fromJson(data[0] as Map<String, dynamic>)
          : MoodFace(dominantEmotion: '', emotionSentence: '');
    } catch (e) {
      print("Error during mood analysis: $e");
      rethrow;
    }
  }

  static Future<List<MoodType>> getMoodTypes(String gender) async {
    final res = await ApiClient.request(
      "/MoodType",
      method: HttpMethod.get,
      query: {'gender': gender},
    );
    try {
      final root = (res as Map).cast<String, dynamic>();
      final List<dynamic> data = (root['data'] as List).cast<dynamic>();
      return MoodType.fromJsonList(data);
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách mood type: $e');
    }
  }

  static Future<MoodType> getMoodTypeById(int id, String gender) async {
    final res = await ApiClient.request(
      "/MoodType/$id",
      method: HttpMethod.get,
      query: {'gender': gender},
    );
    try {
      final root = (res as Map).cast<String, dynamic>();
      final Map<String, dynamic> data = (root['data'] as Map)
          .cast<String, dynamic>();
      return MoodType.fromJson(data);
    } catch (e) {
      throw Exception('Lỗi khi lấy mood type với id $id: $e');
    }
  }

  static Future<void> updateMood(int moodTypeId) async {
    try {
      await ApiClient.request(
        "/MoodType/update-mood",
        method: HttpMethod.post,
        data: {'moodTypeId': moodTypeId},
      );
    } catch (e) {
      throw Exception('Lỗi khi cập nhật mood: $e');
    }
  }

  static Future<String> getCurrentMood() async {
    try {
      final res = await ApiClient.request(
        "/MoodType/current-mood",
        method: HttpMethod.get,
      );
      final root = (res as Map).cast<String, dynamic>();
      final Map<String, dynamic> mood = root['data'] as Map<String, dynamic>;
      return mood['currentMood'] as String;
    } catch (e) {
      throw Exception('Lỗi khi lấy mood hiện tại: $e');
    }
  }
}
