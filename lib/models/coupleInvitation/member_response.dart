class MemberResponse {
  final int memberProfileId;
  final int userId;
  final String fullName;
  final String? avatarUrl;
  final String? personalityResultCode;
  final String? jobTitle;
  final String? bio;
  final String relationshipStatus;
  final bool canSendInvitation;
  final int? age;

  MemberResponse({
    required this.memberProfileId,
    required this.userId,
    required this.fullName,
    this.avatarUrl,
    this.personalityResultCode,
    this.jobTitle,
    this.bio,
    required this.relationshipStatus,
    required this.canSendInvitation,
    this.age,
  });

  factory MemberResponse.fromJson(Map<String, dynamic> json) {
    return MemberResponse(
      memberProfileId: json['memberProfileId'],
      userId: json['userId'],
      fullName: json['fullName'],
      avatarUrl: json['avatarUrl'],
      personalityResultCode: json['personalityResultCode'],
      jobTitle: json['jobTitle'],
      bio: json['bio'],
      relationshipStatus: json['relationshipStatus'],
      canSendInvitation: json['canSendInvitation'],
      age: json['age'],
    );
  }
}
