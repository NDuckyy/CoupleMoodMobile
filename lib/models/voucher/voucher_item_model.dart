class VoucherItem {
  final int id;
  final int venueOwnerId;
  final String code;
  final String title;
  final String description;

  final int pointPrice;

  final String discountType;
  final int? discountAmount;
  final double? discountPercent;

  final int quantity;
  final int remainingQuantity;

  final int? usageLimitPerMember;
  final int? usageValidDays;

  final String status;

  final DateTime startDate;
  final DateTime endDate;

  final DateTime createdAt;
  final DateTime updatedAt;

  final List<VoucherLocation> locations;

  VoucherItem({
    required this.id,
    required this.venueOwnerId,
    required this.code,
    required this.title,
    required this.description,
    required this.pointPrice,
    required this.discountType,
    this.discountAmount,
    this.discountPercent,
    required this.quantity,
    required this.remainingQuantity,
    this.usageLimitPerMember,
    this.usageValidDays,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    required this.locations,
  });

  /// ---------- SAFE PARSE ----------
  static int _toInt(dynamic value) => (value as num?)?.toInt() ?? 0;

  static int? _toNullableInt(dynamic value) => (value as num?)?.toInt();

  static double? _toDouble(dynamic value) => (value as num?)?.toDouble();

  static DateTime _toDate(dynamic value) {
    if (value == null) return DateTime.now();
    return DateTime.tryParse(value.toString()) ?? DateTime.now();
  }

  static List<VoucherLocation> _toLocations(dynamic value) {
    if (value is List) {
      return value.map((e) => VoucherLocation.fromJson(e)).toList();
    }
    return [];
  }

  factory VoucherItem.fromJson(Map<String, dynamic> json) {
    return VoucherItem(
      id: _toInt(json['id']),
      venueOwnerId: _toInt(json['venueOwnerId']),
      code: json['code'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      pointPrice: _toInt(json['pointPrice']),
      discountType: json['discountType'] ?? '',
      discountAmount: _toNullableInt(json['discountAmount']),
      discountPercent: _toDouble(json['discountPercent']),
      quantity: _toInt(json['quantity']),
      remainingQuantity: _toInt(json['remainingQuantity']),
      usageLimitPerMember: _toNullableInt(json['usageLimitPerMember']),
      usageValidDays: _toNullableInt(json['usageValiDays']), // backend typo
      status: json['status'] ?? '',
      startDate: _toDate(json['startDate']),
      endDate: _toDate(json['endDate']),
      createdAt: _toDate(json['createdAt']),
      updatedAt: _toDate(json['updatedAt']),
      locations: _toLocations(json['locations']),
    );
  }
}

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
