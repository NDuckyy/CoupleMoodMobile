import 'package:couple_mood_mobile/models/user/member_profile_model.dart';

class UserModel {
  final int id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String? avatarUrl;
  final String role;
  final bool isActive;

  final String? lastLoginAt;
  final String? createdAt;
  final String? updatedAt;

  final MemberProfileModel? memberProfile;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    this.avatarUrl,
    required this.role,
    required this.isActive,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
    this.memberProfile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      avatarUrl: json['avatarUrl'],
      role: json['role'],
      isActive: json['isActive'] ?? true,
      lastLoginAt: json['lastLoginAt'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      memberProfile: json['memberProfile'] != null
          ? MemberProfileModel.fromJson(json['memberProfile'])
          : null,
    );
  }
}
