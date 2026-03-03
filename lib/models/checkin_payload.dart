class CheckInPayload {
  final int venueLocationId;
  final double latitude;
  final double longitude;

  CheckInPayload({
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