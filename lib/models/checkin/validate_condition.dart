class ValidateCondition {
  final int venueLocationId;
  final double latitude;
  final double longitude;

  ValidateCondition({
    required this.venueLocationId,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
    "venueLocationId": venueLocationId,
    "latitude": latitude,
    "longitude": longitude,
  };
}
