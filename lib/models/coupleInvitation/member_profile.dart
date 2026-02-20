class MemberProfile {
  final int id;
  final String fullName;
  final DateTime dateOfBirth;
  final String gender;
  final String? bio;
  final String relationshipStatus;
  final double? homeLatitude;
  final double? homeLongitude;
  final double budgetMin;
  final double? budgetMax;
  final Interests? interests;
  final AvailableTime? availableTime;

  MemberProfile({
    required this.id,
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    this.bio,
    required this.relationshipStatus,
    this.homeLatitude,
    this.homeLongitude,
    required this.budgetMin,
    this.budgetMax,
    this.interests,
    this.availableTime,
  });

  factory MemberProfile.fromJson(Map<String, dynamic> json) {
    return MemberProfile(
      id: json['id'],
      fullName: json['fullName'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      gender: json['gender'],
      bio: json['bio'],
      relationshipStatus: json['relationshipStatus'],
      homeLatitude: json['homeLatitude'] == null ? null : (json['homeLatitude'] as num).toDouble(),
      homeLongitude: json['homeLongitude'] == null ? null : (json['homeLongitude'] as num).toDouble(),
      budgetMin: json['budgetMin'],
      budgetMax: json['budgetMax'],
      interests: json['interests'] == null ? null : Interests.fromJson(json['interests']),
      availableTime: json['availableTime'] == null ? null : AvailableTime.fromJson(json['availableTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'bio': bio,
      'relationshipStatus': relationshipStatus,
      'homeLatitude': homeLatitude,
      'homeLongitude': homeLongitude,
      'budgetMin': budgetMin,
      'budgetMax': budgetMax,
      'interests': interests?.toJson(),
      'availableTime': availableTime?.toJson(),
    };
  }

  int get age {
    final today = DateTime.now();
    int age = today.year - dateOfBirth.year;
    if (today.month < dateOfBirth.month ||
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }
}

class Interests {
  final List<String> sothich;

  Interests({required this.sothich});

  factory Interests.fromJson(Map<String, dynamic> json) {
    return Interests(sothich: List<String>.from(json['sothich'] ?? []));
  }

  Map<String, dynamic> toJson() {
    return {'sothich': sothich};
  }
}

class AvailableTime {
  final List<String> sang;
  final List<String> toi;
  final List<String> cuoiTuan;

  AvailableTime({
    required this.sang,
    required this.toi,
    required this.cuoiTuan,
  });

  factory AvailableTime.fromJson(Map<String, dynamic> json) {
    return AvailableTime(
      sang: List<String>.from(json['sang'] ?? []),
      toi: List<String>.from(json['toi'] ?? []),
      cuoiTuan: List<String>.from(json['cuoi_tuan'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {'sang': sang, 'toi': toi, 'cuoi_tuan': cuoiTuan};
  }
}
