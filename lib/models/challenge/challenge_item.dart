class ChallengeItem {
  final int id;
  final String title;
  final String description;
  final String triggerEvent;
  final String goalMetric;
  final int targetGoal;
  final int rewardPoints;

  final bool isJoined;

  /// optional
  final int? currentProgress;
  final int? coupleChallengeId;

  ChallengeItem({
    required this.id,
    required this.title,
    required this.description,
    required this.triggerEvent,
    required this.goalMetric,
    required this.targetGoal,
    required this.rewardPoints,
    required this.isJoined,
    this.currentProgress,
    this.coupleChallengeId,
  });

  factory ChallengeItem.fromJson(Map<String, dynamic> json) {
    return ChallengeItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      triggerEvent: json['triggerEvent'],
      goalMetric: json['goalMetric'],
      targetGoal: json['targetGoal'],
      rewardPoints: json['rewardPoints'],
      isJoined: json['isJoined'] ?? false,
      currentProgress: json['currentProgress'],
      coupleChallengeId: json['coupleChallengeId'],
    );
  }
}
