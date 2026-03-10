class MediaModel {
  final String url;
  final String type;

  MediaModel({required this.url, required this.type});

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(url: json['url'] ?? '', type: json['type'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {"url": url, "type": type};
  }
}
