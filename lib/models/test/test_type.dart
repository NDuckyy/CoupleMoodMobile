class TestType {
  final String id;
  final String name;
  final String description;
  final int totalQuestions;

  TestType({
    required this.id,
    required this.name,
    required this.description,
    required this.totalQuestions,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'totalQuestions': totalQuestions,
  };

  factory TestType.fromJson(Map<String, dynamic> json) {
    return TestType(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      totalQuestions: json['totalQuestions'] is int
          ? json['totalQuestions'] as int
          : int.tryParse(json['totalQuestions']?.toString() ?? '') ?? 0,
    );
  }
  static List<TestType> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((e) => TestType.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
