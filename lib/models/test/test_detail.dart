import 'package:couple_mood_mobile/models/test/test_answer.dart';

class TestDetail {
  final int questionId;
  final String content;
  final String answerType;
  final String dimension;
  final List<TestAnswer> options;

  TestDetail({
    required this.questionId,
    required this.content,
    required this.answerType,
    required this.dimension,
    required this.options,
  });

  factory TestDetail.fromJson(Map<String, dynamic> json) {
    return TestDetail(
      questionId: json['questionId'] as int,
      content: json['content']?.toString() ?? '',
      answerType: json['answerType']?.toString() ?? '',
      dimension: json['dimension']?.toString() ?? '',
      options: json['options'] != null
          ? TestAnswer.fromJsonList((json['options'] as List).cast<dynamic>())
          : [],
    );
  }

  static List<TestDetail> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((e) => TestDetail.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Map<String, dynamic> toJson() => {
  //   'id': id,
  //   'content': content,
  //   'answerType': answerType,
  //   'dimension': dimension,
  //   'answers': answers.map((e) => e.toJson()).toList(),
  // };
}
