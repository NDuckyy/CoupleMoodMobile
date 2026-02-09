class Session {
  final String accessToken;
  final String? refreshToken;

  final int? userId;
  final String? gender;
  final String? avartarUrl;

  Session({
    required this.accessToken,
    this.refreshToken,
    this.userId,
    this.gender,
    this.avartarUrl,
  });

   Map<String, dynamic> profileToJson() => {
        'userId': userId,
        'gender': gender,
        'avartarUrl': avartarUrl,
      };

  factory Session.fromTokensAndProfile({
    required String accessToken,
    String? refreshToken,
    Map<String, dynamic>? profile,
  }) {
    return Session(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: profile?['userId'] as int?,
      gender: profile?['gender']?.toString(),
      avartarUrl: profile?['avartarUrl']?.toString(),
    );
  }
}