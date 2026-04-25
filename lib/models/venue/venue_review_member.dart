import 'package:couple_mood_mobile/models/venue/member_accessory.dart';

class VenueReviewMember {
  final int id;
  final int userId;
  final String? fullName;
  final String? displayName;
  final String? gender;
  final String? bio;
  final String? avatarUrl;
  final String? email;

  // NEW
  final List<MemberAccessory> equippedAccessories;

  VenueReviewMember({
    required this.id,
    required this.userId,
    this.fullName,
    this.displayName,
    this.gender,
    this.bio,
    this.avatarUrl,
    this.email,
    required this.equippedAccessories,
  });

  factory VenueReviewMember.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return VenueReviewMember(id: 0, userId: 0, equippedAccessories: []);
    }

    return VenueReviewMember(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      fullName: json['fullName'],
      displayName: json['displayName'],
      gender: json['gender'],
      bio: json['bio'],
      avatarUrl: json['avatarUrl'],
      email: json['email'],

      // NEW
      equippedAccessories:
          (json['equippedAccessories'] as List?)
              ?.map((e) => MemberAccessory.fromJson(e))
              .toList() ??
          [],
    );
  }
}
