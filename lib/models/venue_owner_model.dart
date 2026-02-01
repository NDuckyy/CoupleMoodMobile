class VenueOwner {
  final int id;
  final String businessName;
  final String phoneNumber;
  final String email;
  final String address;

  VenueOwner({
    required this.id,
    required this.businessName,
    required this.phoneNumber,
    required this.email,
    required this.address,
  });

  factory VenueOwner.fromJson(Map<String, dynamic> json) {
    return VenueOwner(
      id: (json['id'] as num?)?.toInt() ?? 0,
      businessName: json['businessName']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
    );
  }
}
