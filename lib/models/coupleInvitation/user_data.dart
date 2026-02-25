import 'package:couple_mood_mobile/models/coupleInvitation/member_profile.dart';

class UserData {
  final int id;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String role;
  final bool isActive;
  final DateTime lastLoginAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MemberProfile? memberProfile;

  UserData({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.role,
    required this.isActive,
    required this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
    this.memberProfile,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      isActive: json['isActive'],
      lastLoginAt: DateTime.parse(json['lastLoginAt']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      memberProfile: json['memberProfile'] != null
          ? MemberProfile.fromJson(json['memberProfile'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'isActive': isActive,
      'lastLoginAt': lastLoginAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'memberProfile': memberProfile?.toJson(),
    };
  }
}
