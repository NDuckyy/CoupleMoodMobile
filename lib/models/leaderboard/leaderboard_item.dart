class LeaderboardItem {
  final int id;
  final int coupleId;
  final String coupleName;
  final int totalPoints;
  final int rankPosition;
  final DateTime updatedAt;

  LeaderboardItem({
    required this.id,
    required this.coupleId,
    required this.coupleName,
    required this.totalPoints,
    required this.rankPosition,
    required this.updatedAt,
  });

  factory LeaderboardItem.fromJson(Map<String, dynamic> json) {
    return LeaderboardItem(
      id: json['id'],
      coupleId: json['coupleId'],
      coupleName: json['coupleName'],
      totalPoints: json['totalPoints'],
      rankPosition: json['rankPosition'],
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
