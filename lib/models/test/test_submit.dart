class UserAnswer {
  final String questionId;
  final String answerId;

  UserAnswer({required this.questionId, required this.answerId});

  Map<String, dynamic> toJson() {
    return {'questionId': questionId, 'answerId': answerId};
  }
}

class TestSubmit {
  final String action;
  final int currentQuestionIndex;
  final List<UserAnswer> answers;

  TestSubmit({
    required this.action,
    required this.currentQuestionIndex,
    required this.answers,
  });

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'currentQuestionIndex': currentQuestionIndex,
      'answers': answers.map((answer) => answer.toJson()).toList(),
    };
  }
}
