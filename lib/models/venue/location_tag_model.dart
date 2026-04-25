class LocationTag {
  final int id;
  final String name;
  final String? description;

  LocationTag({required this.id, required this.name, this.description});

  factory LocationTag.fromJson(Map<String, dynamic> json) {
    return LocationTag(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description'],
    );
  }
}
