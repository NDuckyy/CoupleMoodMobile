class MemberProfile {
  final int id;
  final String fullName;
  final DateTime? dateOfBirth;
  final String? gender;
  final int? age;
  final List<String>? personalityDescription;
  final String? bio;
  final String relationshipStatus;
  final String? jobTitle;
  final String? educationLevel;
  final double? height;
  final double? weight;
  final String? city;
  final String? district;
  final double? homeLatitude;
  final double? homeLongitude;
  final double? budgetMin;
  final double? budgetMax;
  final List<String>? favoritePets;
  final bool? hasPet;
  final bool? smoking;
  final List<String>? interests;

  MemberProfile({
    required this.id,
    required this.fullName,
    this.dateOfBirth,
    this.gender,
    this.age,
    this.personalityDescription,
    this.bio,
    required this.relationshipStatus,
    this.jobTitle,
    this.educationLevel,
    this.height,
    this.weight,
    this.city,
    this.district,
    this.homeLatitude,
    this.homeLongitude,
    this.budgetMin,
    this.budgetMax,
    this.favoritePets,
    this.hasPet,
    this.smoking,
    this.interests,
  });

  factory MemberProfile.fromJson(Map<String, dynamic> json) {
    return MemberProfile(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      gender: json['gender'],
      age: json['age'],
      personalityDescription: json['personalityDescription'] is List
          ? (json['personalityDescription'] as List).cast<String>()
          : null,
      bio: json['bio'],
      relationshipStatus: json['relationshipStatus'] ?? 'SINGLE',
      jobTitle: json['jobTitle'],
      educationLevel: json['educationLevel'],
      height: json['height'] == null
          ? null
          : (json['height'] as num).toDouble(),
      weight: json['weight'] == null
          ? null
          : (json['weight'] as num).toDouble(),
      city: json['city'],
      district: json['district'],

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
      favoritePets: json['favoritePets'] is List
          ? (json['favoritePets'] as List).cast<String>()
          : null,
      hasPet: json['hasPet'],
      smoking: json['smoking'],
      interests: json['interests'] is List
          ? (json['interests'] as List).cast<String>()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'bio': bio,
      'personalityDescription': personalityDescription,
      'relationshipStatus': relationshipStatus,
      'homeLatitude': homeLatitude,
      'homeLongitude': homeLongitude,
      'budgetMin': budgetMin,
      'budgetMax': budgetMax,
      'jobTitle': jobTitle,
      'educationLevel': educationLevel,
      'height': height,
      'weight': weight,
      'city': city,
      'district': district,
      'favoritePets': favoritePets,
      'hasPet': hasPet,
      'smoking': smoking,
      'interests': interests,
    };
  }
}
