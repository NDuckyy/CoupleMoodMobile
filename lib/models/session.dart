class Session {
  final String accessToken;
  final String? refreshToken;

  final int? userId;
  final String? gender;
  final String? avatarUrl;
  final String? fullName;
  final String? dateOfBirth;
  final String? inviteCode;

  Session({
    required this.accessToken,
    this.refreshToken,
    this.userId,
    this.gender,
    this.avatarUrl,
    this.fullName,
    this.dateOfBirth,
    this.inviteCode,
  });

  Map<String, dynamic> profileToJson() => {
    'userId': userId,
    'gender': gender,
    'avatarUrl': avatarUrl,
    'fullName': fullName,
    'dateOfBirth': dateOfBirth,
    'inviteCode': inviteCode,
  };

  factory Session.fromTokensAndProfile({
    required String accessToken,
    String? refreshToken,
    Map<String, dynamic>? profile,
    int? userIdFromToken,
  }) {
    return Session(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: profile?['userId'] as int? ?? userIdFromToken,
      gender: profile?['gender']?.toString(),
      avatarUrl: profile?['avatarUrl']?.toString(),
      fullName: profile?['fullName']?.toString(),
      dateOfBirth: profile?['dateOfBirth']?.toString(),
      inviteCode: profile?['inviteCode']?.toString(),
    );
  }
}
