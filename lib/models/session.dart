class Session {
  final String accessToken;
  final String? refreshToken;

  final String? cometChatUid;
  final String? cometChatAuthToken;
  final String? gender;
  final String? avartarUrl;

  Session({
    required this.accessToken,
    this.refreshToken,
    this.cometChatUid,
    this.cometChatAuthToken,
    this.gender,
    this.avartarUrl,
  });

   Map<String, dynamic> profileToJson() => {
        'cometChatUid': cometChatUid,
        'cometChatAuthToken': cometChatAuthToken,
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
      cometChatUid: profile?['cometChatUid']?.toString(),
      cometChatAuthToken: profile?['cometChatAuthToken']?.toString(),
      gender: profile?['gender']?.toString(),
      avartarUrl: profile?['avartarUrl']?.toString(),
    );
  }
}