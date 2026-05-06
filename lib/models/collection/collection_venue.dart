class CollectionVenue {
  final int id;
  final String name;
  final String description;
  final String address;
  final List<String> coverImage;
  final List<String> interiorImage;

  CollectionVenue({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.coverImage,
    required this.interiorImage,
  });

  factory CollectionVenue.fromJson(Map<String, dynamic> json) {
    return CollectionVenue(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',

      coverImage: (json['coverImage'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),

      interiorImage: (json['interiorImage'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}
