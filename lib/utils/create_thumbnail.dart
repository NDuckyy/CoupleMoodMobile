import 'dart:typed_data';

import 'package:video_thumbnail/video_thumbnail.dart';

class CreateThumbnail {
  static Future<Uint8List?> generateThumbnail(String url) async {
    return await VideoThumbnail.thumbnailData(
      video: url,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 200,
      quality: 75,
    );
  }
}
