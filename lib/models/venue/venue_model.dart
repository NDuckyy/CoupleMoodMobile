import 'location_tag_model.dart';
import 'venue_owner_model.dart';
import 'today_opening_hour.dart';

class Venue {
  final int id;
  final String name;
  final String description;
  final String address;

  final String? email;
  final String? phoneNumber;
  final String? websiteUrl;

  final double? latitude;
  final double? longitude;

  final double averageRating;
  final int reviewCount;
  final int favoriteCount;

  final int priceMin;
  final int priceMax;
  final int averageCost;

  final List<String> coverImages;
  final List<String> interiorImages;
  final List<String> fullPageMenuImages;

  final List<LocationTag> coupleMoodTypes;
  final List<LocationTag> couplePersonalityTypes;

  final VenueOwner? venueOwner;
  final TodayOpeningHour? todayOpeningHour;

  final String? todayDayName;
  final String status;
  final bool isOwnerVerified;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  Venue({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.averageRating,
    required this.reviewCount,
    required this.favoriteCount,
    required this.priceMin,
    required this.priceMax,
    required this.averageCost,
    required this.coverImages,
    required this.interiorImages,
    required this.fullPageMenuImages,
    required this.coupleMoodTypes,
    required this.couplePersonalityTypes,
    required this.status,
    required this.isOwnerVerified,
    this.email,
    this.phoneNumber,
    this.websiteUrl,
    this.latitude,
    this.longitude,
    this.venueOwner,
    this.todayOpeningHour,
    this.todayDayName,
    this.createdAt,
    this.updatedAt,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',

      email: json['email'],
      phoneNumber: json['phoneNumber'],
      websiteUrl: json['websiteUrl'],

      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),

      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      favoriteCount: (json['favoriteCount'] as num?)?.toInt() ?? 0,

      priceMin: (json['priceMin'] as num?)?.toInt() ?? 0,
      priceMax: (json['priceMax'] as num?)?.toInt() ?? 0,
      averageCost:
          (json['avarageCost'] ?? json['averageCost'] as num?)?.toInt() ?? 0,

      coverImages: List<String>.from(json['coverImage'] ?? []),
      interiorImages: List<String>.from(json['interiorImage'] ?? []),
      fullPageMenuImages: List<String>.from(json['fullPageMenuImage'] ?? []),

      coupleMoodTypes: (json['coupleMoodTypes'] as List? ?? [])
          .map((e) => LocationTag.fromJson(e))
          .toList(),

      couplePersonalityTypes: (json['couplePersonalityTypes'] as List? ?? [])
          .map((e) => LocationTag.fromJson(e))
          .toList(),

      venueOwner: json['venueOwner'] != null
          ? VenueOwner.fromJson(json['venueOwner'])
          : null,

      todayOpeningHour: json['todayOpeningHour'] != null
          ? TodayOpeningHour.fromJson(json['todayOpeningHour'])
          : null,

      todayDayName: json['todayDayName'],
      status: json['status'] ?? '',
      isOwnerVerified: json['isOwnerVerified'] ?? false,

      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,

      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }
}
