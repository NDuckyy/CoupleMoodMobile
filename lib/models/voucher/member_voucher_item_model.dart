class MemberVoucherItem {
  final int id;
  final String title;
  final String description;
  final int pointPrice;
  final String discountType;
  final int? discountAmount;
  final double? discountPercent;
  final int quantity;
  final int remainingQuantity;
  final String status;
  final DateTime startDate;
  final DateTime endDate;

  MemberVoucherItem({
    required this.id,
    required this.title,
    required this.description,
    required this.pointPrice,
    required this.discountType,
    this.discountAmount,
    this.discountPercent,
    required this.quantity,
    required this.remainingQuantity,
    required this.status,
    required this.startDate,
    required this.endDate,
  });

  ///  helper parse an toàn
  static int _toInt(dynamic value) => (value as num?)?.toInt() ?? 0;
  static int? _toNullableInt(dynamic value) => (value as num?)?.toInt();
  static double? _toDouble(dynamic value) => (value as num?)?.toDouble();

  static DateTime _toDate(dynamic value) {
    if (value == null) return DateTime.now();
    return DateTime.tryParse(value.toString()) ?? DateTime.now();
  }

  factory MemberVoucherItem.fromJson(Map<String, dynamic> json) {
    return MemberVoucherItem(
      id: _toInt(json['id']),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      pointPrice: _toInt(json['pointPrice']),
      discountType: json['discountType'] ?? '',
      discountAmount: _toNullableInt(json['discountAmount']),
      discountPercent: _toDouble(json['discountPercent']),
      quantity: _toInt(json['quantity']),
      remainingQuantity: _toInt(json['remainingQuantity']),
      status: json['status'] ?? '',
      startDate: _toDate(json['startDate']),
      endDate: _toDate(json['endDate']),
    );
  }
}
