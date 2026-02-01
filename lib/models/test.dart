class Test {
  final String name;
  final String description;
  final int totalQuestions;

  Test({
    required this.name,
    required this.description,
    required this.totalQuestions,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'totalQuestions': totalQuestions,
  };

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      totalQuestions: json['totalQuestions'] is int
          ? json['totalQuestions'] as int
          : int.tryParse(json['totalQuestions']?.toString() ?? '') ?? 0,
    );
  }
  static List<Test> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((e) => Test.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
