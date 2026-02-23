class MemberResponse {
  final int memberProfileId;
  final int userId;
  final String fullName;
  final String? avatarUrl;
  final String? bio;
  final String relationshipStatus;
  final bool canSendInvitation;

  MemberResponse({
    required this.memberProfileId,
    required this.userId,
    required this.fullName,
    this.avatarUrl,
    this.bio,
    required this.relationshipStatus,
    required this.canSendInvitation,
  });

  factory MemberResponse.fromJson(Map<String, dynamic> json) {
    return MemberResponse(
      memberProfileId: json['memberProfileId'],
      userId: json['userId'],
      fullName: json['fullName'],
      avatarUrl: json['avatarUrl'],
      bio: json['bio'],
      relationshipStatus: json['relationshipStatus'],
      canSendInvitation: json['canSendInvitation'],
    );
  }
}
