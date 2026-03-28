class UpdateProfileRequest {
  final String fullName;
  final String dateOfBirth;
  final String gender;
  final String? bio;
  final double? homeLatitude;
  final double? homeLongitude;
  final double? budgetMin;
  final double? budgetMax;
  final String? avatarUrl;
  final String phoneNumber;

  const UpdateProfileRequest({
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    this.bio,
    this.homeLatitude,
    this.homeLongitude,
    this.budgetMin,
    this.budgetMax,
    this.avatarUrl,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "dateOfBirth": dateOfBirth,
      "gender": gender,
      "bio": bio,
      "homeLatitude": homeLatitude ?? 0,
      "homeLongitude": homeLongitude ?? 0,
      "budgetMin": budgetMin ?? 0,
      "budgetMax": budgetMax ?? 0,
      "address": null,
      "area": null,
      "avatarUrl": avatarUrl,
      "phoneNumber": phoneNumber,
    };
  }
}
