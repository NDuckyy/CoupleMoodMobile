class LocationTag {
  final int id;
  final String name;

  LocationTag({required this.id, required this.name});

  factory LocationTag.fromJson(Map<String, dynamic> json) {
    return LocationTag(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }
}
