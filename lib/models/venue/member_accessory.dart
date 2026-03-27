class MemberAccessory {
  final int memberAccessoryId;
  final int accessoryId;
  final String code;
  final String name;
  final String type;
  final String? thumbnailUrl;
  final String? resourceUrl;

  MemberAccessory({
    required this.memberAccessoryId,
    required this.accessoryId,
    required this.code,
    required this.name,
    required this.type,
    this.thumbnailUrl,
    this.resourceUrl,
  });

  factory MemberAccessory.fromJson(Map<String, dynamic> json) {
    return MemberAccessory(
      memberAccessoryId: json['memberAccessoryId'] ?? 0,
      accessoryId: json['accessoryId'] ?? 0,
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      thumbnailUrl: json['thumbnailUrl'],
      resourceUrl: json['resourceUrl'],
    );
  }
}
