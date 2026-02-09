class TodayOpeningHour {
  final String openTime;
  final String closeTime;
  final bool isClosed;
  final String status;

  TodayOpeningHour({
    required this.openTime,
    required this.closeTime,
    required this.isClosed,
    required this.status,
  });

  factory TodayOpeningHour.fromJson(Map<String, dynamic> json) {
    return TodayOpeningHour(
      openTime: json['openTime']?.toString() ?? '',
      closeTime: json['closeTime']?.toString() ?? '',
      isClosed: json['isClosed'] ?? false,
      status: json['status']?.toString() ?? '',
    );
  }
}
