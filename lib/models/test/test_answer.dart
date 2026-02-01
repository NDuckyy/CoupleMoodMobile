class TestAnswer {
  final String answerId;
  final String content;
  final bool isSelected;

  TestAnswer({
    required this.answerId,
    required this.content,
    this.isSelected = false,
  });

  Map<String, dynamic> toJson() => {
    'answerId': answerId,
    'content': content,
    'isSelected': isSelected,
  };

  factory TestAnswer.fromJson(Map<String, dynamic> json) {
    return TestAnswer(
      answerId: json['answerId']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      isSelected: json['isSelected'] is bool
          ? json['isSelected'] as bool
          : (json['isSelected']?.toString().toLowerCase() == 'true' ? true : false),
    );
  }

  static List<TestAnswer> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((e) => TestAnswer.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}