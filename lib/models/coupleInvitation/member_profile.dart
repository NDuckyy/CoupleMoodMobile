class MemberProfile {
  final int id;
  final String fullName;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? bio;
  final String relationshipStatus;
  final double? homeLatitude;
  final double? homeLongitude;
  final double? budgetMin;
  final double? budgetMax;

  MemberProfile({
    required this.id,
    required this.fullName,
    this.dateOfBirth,
    this.gender,
    this.bio,
    required this.relationshipStatus,
    this.homeLatitude,
    this.homeLongitude,
    this.budgetMin,
    this.budgetMax,
  });

  factory MemberProfile.fromJson(Map<String, dynamic> json) {
    return MemberProfile(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      gender: json['gender'],
      bio: json['bio'],
      relationshipStatus: json['relationshipStatus'] ?? 'SINGLE',
      homeLatitude: json['homeLatitude'] == null
          ? null
          : (json['homeLatitude'] as num).toDouble(),
      homeLongitude: json['homeLongitude'] == null
          ? null
          : (json['homeLongitude'] as num).toDouble(),
      budgetMin: json['budgetMin'] == null
          ? null
          : (json['budgetMin'] as num).toDouble(),
      budgetMax: json['budgetMax'] == null
          ? null
          : (json['budgetMax'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'bio': bio,
      'relationshipStatus': relationshipStatus,
      'homeLatitude': homeLatitude,
      'homeLongitude': homeLongitude,
      'budgetMin': budgetMin,
      'budgetMax': budgetMax,
    };
  }

  int? get age {
    if (dateOfBirth == null) return null;

    final today = DateTime.now();
    int age = today.year - dateOfBirth!.year;

    if (today.month < dateOfBirth!.month ||
        (today.month == dateOfBirth!.month && today.day < dateOfBirth!.day)) {
      age--;
    }

    return age;
  }
}
