class AuthorModel {
  final int id;
  final String fullName;
  final String? avatar;
  final String relationshipStatus;

  AuthorModel({
    required this.id,
    required this.fullName,
    required this.avatar,
    required this.relationshipStatus,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id'],
      fullName: json['fullName'] ?? '',
      avatar: json['avatar'],
      relationshipStatus: json['relationshipStatus'] ?? '',
    );
  }
}
