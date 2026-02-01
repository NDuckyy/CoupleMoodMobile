class MoodType {
  final int id;
  final String name;
  final String iconUrl;

  MoodType({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  factory MoodType.fromJson(Map<String, dynamic> json) {
    return MoodType(
      id: json['id'] as int,
      name: json['name'] as String,
      iconUrl: json['iconUrl'] as String,
    );
  }

  static List<MoodType> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((e) => MoodType.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconUrl': iconUrl,
    };
  }
}