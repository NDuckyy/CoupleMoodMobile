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

  static Future<ApiResponse<List<String>>> mediaUpload(
    List<File> files, {
    required UploadType type,
  }) async {
    final formData = FormData.fromMap({
      'files': await Future.wait(
        files.map((file) async {
          final fileName = file.path.split('/').last;
          return MultipartFile.fromFile(file.path, filename: fileName);
        }),
      ),
    });

    final res = await ApiClient.upload(
      '/Media/upload',
      method: HttpMethod.post,
      data: formData,
      query: {'type': type.value},
    );

    return ApiResponse<List<String>>.fromJson(
      res,
      (json) => List<String>.from(json as List),
    );
  }
}
