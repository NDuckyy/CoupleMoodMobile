class CoupleMoodType {
  final int id;
  final String name;
  final String description;
  final bool isActive;

  CoupleMoodType({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
  });

  factory CoupleMoodType.fromJson(Map<String, dynamic> json) {
    return CoupleMoodType(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isActive: json['isActive'] ?? true,
    );
  }
}
