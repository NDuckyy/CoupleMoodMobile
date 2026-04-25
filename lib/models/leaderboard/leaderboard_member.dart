class LeaderboardMember {
  final int memberId;
  final String memberName;
  final String? avatarUrl;

  LeaderboardMember({
    required this.memberId,
    required this.memberName,
    this.avatarUrl,
  });

  factory LeaderboardMember.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return LeaderboardMember(memberId: 0, memberName: '', avatarUrl: null);
    }

    return LeaderboardMember(
      memberId: json['memberId'] ?? 0,
      memberName: json['memberName'] ?? '',
      avatarUrl: json['avatarUrl'],
    );
  }
}
