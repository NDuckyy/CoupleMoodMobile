class CoupleTagDescription {
  final int? id;
  final String? name;
  final String? description;

  CoupleTagDescription({
    this.id,
    this.name,
    this.description,
  });

  factory CoupleTagDescription.fromJson(Map<String, dynamic> json) {
    return CoupleTagDescription(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
    );
  }
}