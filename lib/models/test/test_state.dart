class TestState {
  final String state;
  final String testTypeId;
  final int currentQuestionIndex;
  final int answeredCount;
  final int totalQuestions;

  TestState({
    required this.state,
    required this.testTypeId,
    required this.currentQuestionIndex,
    required this.answeredCount,
    required this.totalQuestions,
  });

  factory TestState.fromJson(Map<String, dynamic> json) {
    return TestState(
      state: json['state']?.toString() ?? '',
      testTypeId: json['TestTypeId']?.toString() ?? '',
      currentQuestionIndex: json['currentQuestionIndex'] is int
          ? json['currentQuestionIndex'] as int
          : int.tryParse(json['currentQuestionIndex']?.toString() ?? '') ?? 0,
      answeredCount: json['answeredCount'] is int
          ? json['answeredCount'] as int
          : int.tryParse(json['answeredCount']?.toString() ?? '') ?? 0,
      totalQuestions: json['totalQuestions'] is int
          ? json['totalQuestions'] as int
          : int.tryParse(json['totalQuestions']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'state': state,
        'TestTypeId': testTypeId,
        'currentQuestionIndex': currentQuestionIndex,
        'answeredCount': answeredCount,
        'totalQuestions': totalQuestions,
      };
}