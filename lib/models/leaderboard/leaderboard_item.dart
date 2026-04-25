import 'leaderboard_member.dart';

class LeaderboardItem {
  final int id;
  final int coupleId;
  final String coupleName;

  final LeaderboardMember member1;
  final LeaderboardMember member2;

  final int totalPoints;
  final int rankPosition;
  final DateTime updatedAt;

  LeaderboardItem({
    required this.id,
    required this.coupleId,
    required this.coupleName,
    required this.member1,
    required this.member2,
    required this.totalPoints,
    required this.rankPosition,
    required this.updatedAt,
  });

  factory LeaderboardItem.fromJson(Map<String, dynamic> json) {
    return LeaderboardItem(
      id: json['id'] ?? 0,
      coupleId: json['coupleId'] ?? 0,
      coupleName: json['coupleName'] ?? '',

      member1: LeaderboardMember.fromJson(json['member1']),
      member2: LeaderboardMember.fromJson(json['member2']),

      totalPoints: json['totalPoints'] ?? 0,
      rankPosition: json['rankPosition'] ?? 0,
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
