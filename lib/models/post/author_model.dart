import 'package:couple_mood_mobile/models/venue/member_accessory.dart';

class AuthorModel {
  final int id;
  final String fullName;
  final String? avatar;
  final String relationshipStatus;

  final List<MemberAccessory>? equippedAccessories;

  AuthorModel({
    required this.id,
    required this.fullName,
    required this.avatar,
    required this.relationshipStatus,
    this.equippedAccessories,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id'],
      fullName: json['fullName'] ?? '',
      avatar: json['avatar'],
      relationshipStatus: json['relationshipStatus'] ?? '',

      // 👇 ADD PARSE
      equippedAccessories: (json['equippedAccessories'] as List?)
          ?.map((e) => MemberAccessory.fromJson(e))
          .toList(),
    );
  }
}
