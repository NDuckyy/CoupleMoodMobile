class UpdateProfileRequest {
  final String fullName;
  final String dateOfBirth;
  final String gender;
  final String? bio;

  final String? jobTitle;
  final String? educationLevel;
  final int? height;
  final int? weight;

  final String? city;
  final String? district;

  final double? homeLatitude;
  final double? homeLongitude;

  final double? budgetMin;
  final double? budgetMax;

  final List<String>? favoritePets;
  final bool? hasPet;
  final bool? smoking;

  final String? avatarUrl;
  final String phoneNumber;
  final List<String>? interests;

  const UpdateProfileRequest({
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.phoneNumber,

    this.bio,
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
    this.avatarUrl,
    this.interests,
  });

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "dateOfBirth": dateOfBirth,
      "gender": gender,
      "bio": bio,

      "jobTitle": jobTitle,
      "educationLevel": educationLevel,
      "height": height,
      "weight": weight,

      "city": city,
      "district": district,

      "homeLatitude": homeLatitude,
      "homeLongitude": homeLongitude,

      "budgetMin": budgetMin,
      "budgetMax": budgetMax,

      "favoritePets": favoritePets,
      "hasPet": hasPet,
      "smoking": smoking,

      "avatarUrl": avatarUrl,
      "phoneNumber": phoneNumber,
      "interests": interests,
    }..removeWhere((key, value) => value == null);
  }
}