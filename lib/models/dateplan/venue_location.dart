class VenueLocation {
  final int id;
  final String name;
  final String address;
  final String description;
  final List<String> coverImage;

  VenueLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.coverImage,
  });

  factory VenueLocation.fromJson(Map<String, dynamic> json) {
    return VenueLocation(
      id: json['id'],
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      coverImage: json['coverImage'] != null
          ? List<String>.from(json['coverImage'])
          : [],
    );
  }
}
