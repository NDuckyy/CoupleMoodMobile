class Advertisement {
  final String type;
  final int? advertisementId;
  final int? venueId;
  final int? specialEventId;
  final String? bannerUrl;

  Advertisement({
    required this.type,
    this.advertisementId,
    this.venueId,
    this.specialEventId,
    this.bannerUrl,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) {
    return Advertisement(
      type: json['type'] as String,
      advertisementId: json['advertisementId'] as int?,
      venueId: json['venueId'] as int?,
      specialEventId: json['specialEventId'] as int?,
      bannerUrl: json['bannerUrl'] as String?,
    );
  }
}
