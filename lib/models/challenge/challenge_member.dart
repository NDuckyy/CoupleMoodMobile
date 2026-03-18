class ChallengeMember {
  final int memberId;
  final String memberName;
  final String? avatarUrl;

  final bool isCurrentUser;
  final bool isJoined;

  final bool hasDoneToday;
  final int contributionCount;

  ChallengeMember({
    required this.memberId,
    required this.memberName,
    this.avatarUrl,
    required this.isCurrentUser,
    required this.isJoined,
    required this.hasDoneToday,
    required this.contributionCount,
  });

  factory ChallengeMember.fromJson(Map<String, dynamic> json) {
    return ChallengeMember(
      memberId: json['memberId'] ?? 0,
      memberName: json['memberName'] ?? "",
      avatarUrl: json['avatarUrl'],
      isCurrentUser: json['isCurrentUser'] ?? false,
      isJoined: json['isJoined'] ?? false,
      hasDoneToday: json['hasDoneToday'] ?? false,
      contributionCount: json['contributionCount'] ?? 0,
    );
  }
}
