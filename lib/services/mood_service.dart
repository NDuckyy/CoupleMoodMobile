import 'dart:io';

import 'package:couple_mood_mobile/models/mood_type.dart';
import 'package:couple_mood_mobile/services/api_client.dart';
import 'package:dio/dio.dart';

class MoodService {
  static Future<String> getCurrentMoodByCamera(File file) async {
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
          ? data[0]['dominantEmotion']?.toString() ?? ''
          : '';
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
}
