import 'dart:io';
import 'package:couple_mood_mobile/services/upload_service.dart';
import '../models/upload_type.dart';

class UploadUtil {
  static Future<String> uploadImage(File file) async {
    final response = await UploadService.uploadFile(
      file,
      type: UploadType.image,
    );

    if (response.code == 200 && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message);
  }

  static Future<List<String>> mediaUpload(List<File> files) async {
    final response = await UploadService.mediaUpload(
      files,
      type: UploadType.image,
    );

    if (response.code == 200 && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message);
  }
}
