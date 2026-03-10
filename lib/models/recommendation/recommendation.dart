class Recommendation {
  final int? venueLocationId;
  final int? locationTagId;
  final int? venueOwnerId;

  final String? name;
  final String? address;
  final String? description;

  final String? email;
  final String? phoneNumber;
  final String? websiteUrl;

  final DateTime? openingTime;
  final DateTime? closingTime;
  final bool? isOpen;

  final double? priceMin;
  final double? priceMax;

  final double? latitude;
  final double? longitude;
  final String? area;

  final double? averageCost;
  final String? status;
  final String? category;
  final bool? isOwnerVerified;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isDeleted;

  final double? distance;
  final String? distanceText;

  final double? averageRating;
  final int? reviewCount;

  final List<String>? coverImage;
  final List<String>? interiorImage;
  final List<String>? fullPageMenuImage;

  final List<String>? matchedTags;

  const Recommendation({
    this.venueLocationId,
    this.locationTagId,
    this.venueOwnerId,
    this.name,
    this.address,
    this.description,
    this.email,
    this.phoneNumber,
    this.websiteUrl,
    this.openingTime,
    this.closingTime,
    this.isOpen,
    this.priceMin,
    this.priceMax,
    this.latitude,
    this.longitude,
    this.area,
    this.averageCost,
    this.status,
    this.category,
    this.isOwnerVerified,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.distance,
    this.distanceText,
    this.averageRating,
    this.reviewCount,
    this.coverImage,
    this.interiorImage,
    this.fullPageMenuImage,
    this.matchedTags,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDate(dynamic v) =>
        v == null ? null : DateTime.tryParse(v.toString());

    List<String>? _parseList(dynamic v) =>
        v == null ? null : List<String>.from(v);

    return Recommendation(
      venueLocationId: json['venueLocationId'] as int?,
      locationTagId: json['locationTagId'] as int?,
      venueOwnerId: json['venueOwnerId'] as int?,

      name: json['name'] as String?,
      address: json['address'] as String?,
      description: json['description'] as String?,

      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      websiteUrl: json['websiteUrl'] as String?,

      openingTime: _parseDate(json['openingTime']),
      closingTime: _parseDate(json['closingTime']),
      isOpen: json['isOpen'] as bool?,

      priceMin: (json['priceMin'] as num?)?.toDouble(),
      priceMax: (json['priceMax'] as num?)?.toDouble(),

      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      area: json['area'] as String?,

      averageCost: (json['averageCost'] as num?)?.toDouble(),

      status: json['status'] as String?,
      category: json['category'] as String?,
      isOwnerVerified: json['isOwnerVerified'] as bool?,

      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      isDeleted: json['isDeleted'] as bool?,

      distance: (json['distance'] as num?)?.toDouble(),
      distanceText: json['distanceText'] as String?,

      averageRating: (json['averageRating'] as num?)?.toDouble(),
      reviewCount: json['reviewCount'] as int?,

      coverImage: _parseList(json['coverImage']),
      interiorImage: _parseList(json['interiorImage']),
      fullPageMenuImage: _parseList(json['fullPageMenuImage']),
      matchedTags: _parseList(json['matchedTags']),
    );
  }

  /// ===== Helpers cho UI (rất nên có) =====

  String get displayName => name ?? 'Không rõ tên';

  String get displayAddress => address ?? '';

  String get displayDistance =>
      distanceText ??
      (distance != null ? '${distance!.toStringAsFixed(1)} km' : '');

  String? get thumbnailImage =>
      coverImage != null && coverImage!.isNotEmpty ? coverImage!.first : null;

  bool get hasLocation => latitude != null && longitude != null;
}
