class InterestModel {
  final int id;
  final String? name;
  final String? icon;

  InterestModel({required this.id, this.name, this.icon});

  factory InterestModel.fromJson(Map<String, dynamic> json) {
    return InterestModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
    );
  }
}
