class CollectionVenue {
  final int id;
  final String name;
  final String description;
  final String address;
  final String? coverImage;
  final String? interiorImage;

  CollectionVenue({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    this.coverImage,
    this.interiorImage,
  });

  factory CollectionVenue.fromJson(Map<String, dynamic> json) {
    return CollectionVenue(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      coverImage: json['coverImage'],
      interiorImage: json['interiorImage'],
    );
  }
}
