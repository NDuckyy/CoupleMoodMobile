import 'dart:io';

import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/mood/current_mood.dart';
import 'package:couple_mood_mobile/models/mood/mood_face.dart';
import 'package:couple_mood_mobile/models/mood/mood_type.dart';
import 'package:couple_mood_mobile/services/api_client.dart';
import 'package:dio/dio.dart';

class MoodService {
  static Future<ApiResponse<List<MoodFace>>> getCurrentMoodByCamera(
    File file,
  ) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });

    final res = await ApiClient.upload(
      '/Emotion/analyze',
      method: HttpMethod.post,
      data: formData,
    );

    return ApiResponse<List<MoodFace>>.fromJson(
      res,
      (json) => (json as List).map((e) => MoodFace.fromJson(e)).toList(),
    );
  }

  static Future<ApiResponse<List<MoodType>>> getMoodTypes(String gender) async {
    try {
      final res = await ApiClient.request(
        "/MoodType",
        method: HttpMethod.get,
        query: {'gender': gender},
      );
      return ApiResponse<List<MoodType>>.fromJson(
        res,
        (json) => MoodType.fromJsonList(json),
      );
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách mood type: $e');
    }
  }

  static Future<ApiResponse<MoodType>> getMoodTypeById(
    int id,
    String gender,
  ) async {
    try {
      final res = await ApiClient.request(
        "/MoodType/$id",
        method: HttpMethod.get,
        query: {'gender': gender},
      );
      return ApiResponse<MoodType>.fromJson(
        res,
        (json) => MoodType.fromJson(json),
      );
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

  static Future<ApiResponse<CurrentMood>> getCurrentMood() async {
    try {
      final res = await ApiClient.request(
        "/MoodType/current-mood",
        method: HttpMethod.get,
      );
      return ApiResponse<CurrentMood>.fromJson(
        res,
        (json) => CurrentMood.fromJson(json),
      );
    } catch (e) {
      throw Exception('Lỗi khi lấy mood hiện tại: $e');
    }
  }
}
