import 'package:couple_mood_mobile/models/location_tag_model.dart';
import 'package:couple_mood_mobile/models/venue_owner_model.dart';

class Venue {
  final int id;
  final String name;
  final String description;
  final String address;

  final double averageRating;
  final int reviewCount;
  final int priceMin;
  final int priceMax;

  final String? coverImage;
  final String? interiorImage;
  final String? fullPageMenuImage;

  final LocationTag locationTag;

  final VenueOwner? venueOwner;
  final String? todayOpeningHour;
  final String? openingHours;

  Venue({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.averageRating,
    required this.reviewCount,
    required this.priceMin,
    required this.priceMax,
    required this.locationTag,

    this.coverImage,
    this.interiorImage,
    this.fullPageMenuImage,

    this.venueOwner,
    this.todayOpeningHour,
    this.openingHours,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      address: json['address']?.toString() ?? '',

      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      priceMin: (json['priceMin'] as num?)?.toInt() ?? 0,
      priceMax: (json['priceMax'] as num?)?.toInt() ?? 0,

      coverImage: json['coverImage']?.toString(),
      interiorImage: json['interiorImage']?.toString(),
      fullPageMenuImage: json['fullPageMenuImage']?.toString(),

      locationTag: LocationTag.fromJson(
        json['locationTag'] as Map<String, dynamic>,
      ),

      venueOwner: json['venueOwner'] != null
          ? VenueOwner.fromJson(json['venueOwner'] as Map<String, dynamic>)
          : null,

      todayOpeningHour: json['todayOpeningHour']?.toString(),
      openingHours: json['openingHours']?.toString(),
    );
  }
}
