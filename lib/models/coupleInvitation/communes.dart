class Communes {
  final String code;
  final String name;

  Communes({required this.name, required this.code});

  factory Communes.fromJson(Map<String, dynamic> json) {
    return Communes(name: json['name'], code: json['code']);
  }
}
