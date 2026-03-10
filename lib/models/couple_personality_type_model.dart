class CouplePersonalityType {
  final int id;
  final String name;
  final String description;
  final bool isActive;

  CouplePersonalityType({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
  });

  factory CouplePersonalityType.fromJson(Map<String, dynamic> json) {
    return CouplePersonalityType(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isActive: json['isActive'] ?? true,
    );
  }
}
