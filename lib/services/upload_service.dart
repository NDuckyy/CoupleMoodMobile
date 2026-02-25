import 'dart:io';
import 'package:dio/dio.dart';
import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/services/api_client.dart';
import '../models/upload_type.dart';

class UploadService {
  static Future<ApiResponse<String>> uploadFile(
    File file, {
    required UploadType type,
  }) async {
    final fileName = file.path.split('/').last;

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
    });

    final res = await ApiClient.upload(
      '/Upload',
      method: HttpMethod.post,
      data: formData,
      query: {'type': type.value},
    );

    return ApiResponse<String>.fromJson(res, (json) => json.toString());
  }
}
