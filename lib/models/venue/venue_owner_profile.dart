class VenueOwnerProfile {
  final int id;
  final String? businessName;
  final String? phoneNumber;
  final String? email;
  final String? address;

  VenueOwnerProfile({
    required this.id,
    this.businessName,
    this.phoneNumber,
    this.email,
    this.address,
  });

  factory VenueOwnerProfile.fromJson(Map<String, dynamic> json) {
    return VenueOwnerProfile(
      id: json['id'] ?? 0,
      businessName: json['businessName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      address: json['address'],
    );
  }
}
