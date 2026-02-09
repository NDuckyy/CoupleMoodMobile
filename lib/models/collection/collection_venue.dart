class CollectionVenue {
  final int id;
  final String name;
  final String description;
  final String address;

  CollectionVenue({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
  });

  factory CollectionVenue.fromJson(Map<String, dynamic> json) {
    return CollectionVenue(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
    );
  }
}
