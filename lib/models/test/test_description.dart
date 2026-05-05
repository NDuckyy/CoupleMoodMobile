class TestDescription {
  final String? code;
  final String? name;
  final String? definition;
  final String? imageUrl;

  TestDescription({
    this.code,
    this.name,
    this.definition,
    this.imageUrl,
  });

  factory TestDescription.fromJson(Map<String, dynamic> json) {
    return TestDescription(
      code: json['code'] as String?,
      name: json['name'] as String?,
      definition: json['definition'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}