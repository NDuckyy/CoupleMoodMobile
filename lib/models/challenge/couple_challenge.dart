class CoupleChallenge {
  final int id;
  final int challengeId;

  final int currentProgress;
  final int targetProgress;

  final String status;
  final String triggerEvent;

  final String title;
  final String description;
  final int rewardPoints;

  final String? progressText;

  CoupleChallenge({
    required this.id,
    required this.challengeId,
    required this.currentProgress,
    required this.targetProgress,
    required this.status,
    required this.triggerEvent,
    required this.title,
    required this.description,
    required this.rewardPoints,
    this.progressText,
  });

  factory CoupleChallenge.fromJson(Map<String, dynamic> json) {
    final challenge = json['challenge'] ?? {};

    return CoupleChallenge(
      id: json['id'],
      challengeId: json['challengeId'] ?? challenge['id'],

      currentProgress: json['currentProgress'] ?? 0,
      targetProgress: json['targetProgress'] ?? 0,

      status: json['status'] ?? "",
      triggerEvent: challenge['triggerEvent'] ?? "",

      title: challenge['title'] ?? "",
      description: challenge['description'] ?? "",
      rewardPoints: challenge['rewardPoints'] ?? 0,

      progressText: json['progressText'],
    );
  }
}
