import 'challenge_member.dart';

class CoupleChallenge {
  final int id;
  final int challengeId;

  final int currentProgress;
  final int targetProgress;
  final int remainingProgress;

  final bool isJoined;
  final bool isCompleted;
  final bool isRewardClaimed;

  final String status;
  final String triggerEvent;

  final String title;
  final String description;
  final int rewardPoints;

  final String? progressText;

  final Map<String, dynamic>? progressExtra;
  final List<ChallengeMember>? members;

  final List<String> instructions; // rules từ backend

  CoupleChallenge({
    required this.id,
    required this.challengeId,
    required this.currentProgress,
    required this.targetProgress,
    required this.remainingProgress,
    required this.isJoined,
    required this.isCompleted,
    required this.isRewardClaimed,
    required this.status,
    required this.triggerEvent,
    required this.title,
    required this.description,
    required this.rewardPoints,
    required this.instructions,
    this.progressText,
    this.progressExtra,
    this.members,
  });

  factory CoupleChallenge.fromJson(Map<String, dynamic> json) {
    final challenge = json['challenge'] ?? {};

    return CoupleChallenge(
      id: json['id'] ?? 0,
      challengeId: json['challengeId'] ?? challenge['id'] ?? 0,

      currentProgress: json['currentProgress'] ?? 0,
      targetProgress: json['targetProgress'] ?? 0,
      remainingProgress: json['remainingProgress'] ?? 0,

      isJoined: json['isJoined'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      isRewardClaimed: json['isRewardClaimed'] ?? false,

      status: json['status'] ?? "",

      triggerEvent: challenge['triggerEvent'] ?? "",

      title: challenge['title'] ?? "",
      description: challenge['description'] ?? "",
      rewardPoints: challenge['rewardPoints'] ?? 0,

      progressText: json['progressText'],

      progressExtra: json['progressExtra'],

      members:
          (json['members'] as List?)
              ?.map((e) => ChallengeMember.fromJson(e))
              .toList() ??
          [],

      instructions:
          (challenge['instructions'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
