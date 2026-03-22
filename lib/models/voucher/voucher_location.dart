class VoucherLocation {
  final int venueLocationId;
  final String venueLocationName;

  VoucherLocation({
    required this.venueLocationId,
    required this.venueLocationName,
  });

  factory VoucherLocation.fromJson(Map<String, dynamic> json) {
    return VoucherLocation(
      venueLocationId: (json['venueLocationId'] as num?)?.toInt() ?? 0,
      venueLocationName: json['venueLocationName'] ?? '',
    );
  }
}
