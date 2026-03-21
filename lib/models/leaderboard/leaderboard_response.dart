import 'leaderboard_item.dart';

class LeaderboardResponse {
  final String periodType;
  final String seasonKey;
  final DateTime periodStart;
  final DateTime periodEnd;
  final List<LeaderboardItem> rankings;
  final int totalCount;

  LeaderboardResponse({
    required this.periodType,
    required this.seasonKey,
    required this.periodStart,
    required this.periodEnd,
    required this.rankings,
    required this.totalCount,
  });

  factory LeaderboardResponse.fromJson(Map<String, dynamic> json) {
    return LeaderboardResponse(
      periodType: json['periodType'],
      seasonKey: json['seasonKey'],
      periodStart: DateTime.parse(json['periodStart']),
      periodEnd: DateTime.parse(json['periodEnd']),
      rankings: (json['rankings'] as List)
          .map((e) => LeaderboardItem.fromJson(e))
          .toList(),
      totalCount: json['totalCount'],
    );
  }
}
