class Communes {
  final String code;
  final String name;
  final String? provinceName;

  Communes({required this.name, required this.code, this.provinceName});

  factory Communes.fromJson(Map<String, dynamic> json) {
    return Communes(
      name: json['name'],
      code: json['code'],
      provinceName: json['provinceName'],
    );
  }
}
