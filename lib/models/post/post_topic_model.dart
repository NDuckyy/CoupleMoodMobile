class PostTopic {
  final String key;
  final String display;
  final String icon;

  PostTopic({required this.key, required this.display, required this.icon});

  factory PostTopic.fromJson(Map<String, dynamic> json) {
    return PostTopic(
      key: json['key'],
      display: json['display'],
      icon: json['icon'],
    );
  }
}
