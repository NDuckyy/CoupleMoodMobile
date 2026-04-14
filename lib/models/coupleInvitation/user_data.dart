import 'package:couple_mood_mobile/models/coupleInvitation/member_profile.dart';

class UserData {
  final int id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String role;
  final bool isActive;
  final DateTime? lastLoginAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? avatarUrl;
  final double? balance;
  final int? points;
  final MemberProfile? memberProfile;

  UserData({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    required this.role,
    required this.isActive,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
    this.avatarUrl,
    this.balance,
    this.points,
    this.memberProfile,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'],
      role: json['role'] ?? '',
      isActive: json['isActive'] ?? false,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.tryParse(json['lastLoginAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      avatarUrl: json['avatarUrl'],
      balance: json['balance'],
      points: json['points'],
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
      'role': role,
      'isActive': isActive,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'avatarUrl': avatarUrl,
      'balance': balance,
      'points': points,
      'memberProfile': memberProfile?.toJson(),
    };
  }
}