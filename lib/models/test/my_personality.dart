class MyPersonality {
  final String? resultCode;
  final String? imageUrl;

  MyPersonality({this.resultCode, this.imageUrl});

  factory MyPersonality.fromJson(Map<String, dynamic> json) {
    return MyPersonality(
      resultCode: json['resultCode'],
      imageUrl: json['imageUrl'],
    );
  }
}
