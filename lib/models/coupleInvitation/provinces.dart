class Provinces {
  final String code;
  final String name;

  Provinces({required this.name, required this.code});

  factory Provinces.fromJson(Map<String, dynamic> json) {
    return Provinces(
      name: json['name'],
      code: json['code'],
    );
}
}