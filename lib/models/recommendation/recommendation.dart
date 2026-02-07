class Recommendation {
  final int venueLocationId;
  final int? locationTagId;
  final int venueOwnerId;

  final String name;
  final String address;
  final String description;

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

  final double? avarageCost; // giữ nguyên typo backend
  final String? status;
  final String? category;
  final bool? isOwnerVerified;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isDeleted;

  final double? distance;
  final String? distanceText;

  final String matchReason;
  final double? averageRating;
  final int reviewCount;

  final List<String>? coverImage;
  final List<String>? interiorImage;
  final List<String>? fullPageMenuImage;

  final List<String> matchedTags;

  Recommendation({
    required this.venueLocationId,
    this.locationTagId,
    required this.venueOwnerId,
    required this.name,
    required this.address,
    required this.description,
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
    this.avarageCost,
    this.status,
    this.category,
    this.isOwnerVerified,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.distance,
    this.distanceText,
    required this.matchReason,
    this.averageRating,
    required this.reviewCount,
    this.coverImage,
    this.interiorImage,
    this.fullPageMenuImage,
    required this.matchedTags,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      venueLocationId: json['venueLocationId'],
      locationTagId: json['locationTagId'],
      venueOwnerId: json['venueOwnerId'],
      name: json['name'],
      address: json['address'],
      description: json['description'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      websiteUrl: json['websiteUrl'],
      openingTime: json['openingTime'] != null
          ? DateTime.parse(json['openingTime'])
          : null,
      closingTime: json['closingTime'] != null
          ? DateTime.parse(json['closingTime'])
          : null,
      isOpen: json['isOpen'],
      priceMin: (json['priceMin'] as num?)?.toDouble(),
      priceMax: (json['priceMax'] as num?)?.toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      area: json['area'],
      avarageCost: (json['avarageCost'] as num?)?.toDouble(),
      status: json['status'],
      category: json['category'],
      isOwnerVerified: json['isOwnerVerified'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      isDeleted: json['isDeleted'],
      distance: (json['distance'] as num?)?.toDouble(),
      distanceText: json['distanceText'],
      matchReason: json['matchReason'],
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      reviewCount: json['reviewCount'],
      coverImage: json['coverImage'] != null ? List<String>.from(json['coverImage']) : null,
      interiorImage: json['interiorImage'] != null ? List<String>.from(json['interiorImage']) : null,
      fullPageMenuImage: json['fullPageMenuImage'] != null ? List<String>.from(json['fullPageMenuImage']) : null,
      matchedTags: List<String>.from(json['matchedTags']),
    );
  }
}
