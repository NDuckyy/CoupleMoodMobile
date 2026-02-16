enum UploadType { image, video, audio, document }

extension UploadTypeExtension on UploadType {
  String get value {
    switch (this) {
      case UploadType.image:
        return "IMAGE";
      case UploadType.video:
        return "VIDEO";
      case UploadType.audio:
        return "AUDIO";
      case UploadType.document:
        return "DOCUMENT";
    }
  }
}
