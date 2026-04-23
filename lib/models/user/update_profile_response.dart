class UpdateProfileResponse {
  final int memberProfileId;
  final int userId;
  final String fullName;
  final String avatarUrl;
  final String phoneNumber;
  final String dateOfBirth;
  final String gender;
  final String? bio;
  final String relationshipStatus;
  final double homeLatitude;
  final double homeLongitude;
  final double budgetMin;
  final double? budgetMax;
  final List<String>? interests;
  final String? address;
  final String? area;
  final String inviteCode;
  final bool canSendInvitation;

  UpdateProfileResponse({
    required this.memberProfileId,
    required this.userId,
    required this.fullName,
    required this.avatarUrl,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.gender,
    this.bio,
    required this.relationshipStatus,
    required this.homeLatitude,
    required this.homeLongitude,
    required this.budgetMin,
    this.budgetMax,
    this.interests,
    this.address,
    this.area,
    required this.inviteCode,
    required this.canSendInvitation,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponse(
      memberProfileId: json['memberProfileId'],
      userId: json['userId'],
      fullName: json['fullName'],
      avatarUrl: json['avatarUrl'],
      phoneNumber: json['phoneNumber'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      bio: json['bio'],
      relationshipStatus: json['relationshipStatus'],
      homeLatitude: (json['homeLatitude'] as num).toDouble(),
      homeLongitude: (json['homeLongitude'] as num).toDouble(),
      budgetMin: (json['budgetMin'] as num).toDouble(),
      budgetMax: (json['budgetMax'] as num?)?.toDouble(),
      interests: (json['interests'] as List?)?.cast<String>(),
      address: json['address'],
      area: json['area'],
      inviteCode: json['inviteCode'],
      canSendInvitation: json['canSendInvitation'],
    );
  }
}
