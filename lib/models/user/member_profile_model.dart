class MemberProfileModel {
  final int id;
  final String? fullName;
  final String? dateOfBirth;
  final String? gender;
  final String? bio;
  final String? relationshipStatus;
  final double? homeLatitude;
  final double? homeLongitude;
  final double? budgetMin;
  final double? budgetMax;
  final String? interests;
  final String? availableTime;
  final String? inviteCode;

  MemberProfileModel({
    required this.id,
    this.fullName,
    this.dateOfBirth,
    this.gender,
    this.bio,
    this.relationshipStatus,
    this.homeLatitude,
    this.homeLongitude,
    this.budgetMin,
    this.budgetMax,
    this.interests,
    this.availableTime,
    this.inviteCode,
  });

  factory MemberProfileModel.fromJson(Map<String, dynamic> json) {
    return MemberProfileModel(
      id: json['id'],
      fullName: json['fullName'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      bio: json['bio'],
      relationshipStatus: json['relationshipStatus'],
      homeLatitude: (json['homeLatitude'] as num?)?.toDouble(),
      homeLongitude: (json['homeLongitude'] as num?)?.toDouble(),
      budgetMin: (json['budgetMin'] as num?)?.toDouble(),
      budgetMax: (json['budgetMax'] as num?)?.toDouble(),
      interests: json['interests'],
      availableTime: json['availableTime'],
      inviteCode: json['inviteCode'],
    );
  }
}
