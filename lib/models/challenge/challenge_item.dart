class ChallengeItem {
  final int id;
  final String title;
  final String description;
  final String triggerEvent;
  final String goalMetric;
  final int targetGoal;
  final int rewardPoints;

  final bool isJoined;

  /// progress
  final int? currentProgress;
  final int? coupleChallengeId;
  final String? coupleChallengeStatus;
  final DateTime? joinedAt;

  /// reward
  final bool? isCompleted;
  final bool? isRewardClaimed;

  /// rule + instructions
  final Map<String, dynamic>? ruleData;
  final List<String>? instructions;

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
    this.coupleChallengeStatus,
    this.joinedAt,
    this.isCompleted,
    this.isRewardClaimed,
    this.ruleData,
    this.instructions,
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
      coupleChallengeStatus: json['coupleChallengeStatus'],

      joinedAt: json['joinedAt'] != null
          ? DateTime.tryParse(json['joinedAt'])
          : null,

      isCompleted: json['isCompleted'],
      isRewardClaimed: json['isRewardClaimed'] ?? false,

      ruleData: json['ruleData'],

      instructions: (json['instructions'] as List?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }
}
