import 'package:couple_mood_mobile/models/location_tag_model.dart';
import 'package:couple_mood_mobile/models/venue_owner_model.dart';
import 'package:couple_mood_mobile/models/today_opening_hour.dart';

class Venue {
  final int id;
  final String name;
  final String description;
  final String address;

  final double averageRating;
  final int reviewCount;
  final int priceMin;
  final int priceMax;
  final int averageCost;

  final List<String> coverImages;
  final List<String> interiorImages;
  final List<String> fullPageMenuImages;

  final List<LocationTag> locationTags;

  final VenueOwner? venueOwner;

  final TodayOpeningHour? todayOpeningHour;

  Venue({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.averageRating,
    required this.reviewCount,
    required this.priceMin,
    required this.priceMax,
    required this.averageCost,
    required this.coverImages,
    required this.interiorImages,
    required this.fullPageMenuImages,
    required this.locationTags,
    this.venueOwner,
    this.todayOpeningHour,
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
      averageCost: (json['avarageCost'] as num?)?.toInt() ?? 0,

      coverImages: (json['coverImage'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),

      interiorImages: (json['interiorImage'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),

      fullPageMenuImages: (json['fullPageMenuImage'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),

      locationTags: (json['locationTags'] as List? ?? [])
          .map((e) => LocationTag.fromJson(e))
          .toList(),

      venueOwner: json['venueOwner'] != null
          ? VenueOwner.fromJson(json['venueOwner'])
          : null,

      todayOpeningHour: json['todayOpeningHour'] != null
          ? TodayOpeningHour.fromJson(json['todayOpeningHour'])
          : null,
    );
  }
}
