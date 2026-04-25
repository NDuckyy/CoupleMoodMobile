class MyVoucherItem {
  final int voucherItemId;
  final int voucherId;
  final String voucherTitle;
  final String itemCode;
  final String qrCodeUrl;
  final String status;

  final DateTime acquiredAt;
  final DateTime expiredAt;
  final DateTime? usedAt;

  final String? discountType;
  final int? discountAmount;
  final double? discountPercent;

  MyVoucherItem({
    required this.voucherItemId,
    required this.voucherId,
    required this.voucherTitle,
    required this.itemCode,
    required this.qrCodeUrl,
    required this.status,
    required this.acquiredAt,
    required this.expiredAt,
    this.usedAt,
    this.discountType,
    this.discountAmount,
    this.discountPercent,
  });

  /// ---------- SAFE PARSE ----------
  static int _toInt(dynamic v) => (v as num?)?.toInt() ?? 0;
  static double? _toDouble(dynamic v) => (v as num?)?.toDouble();
  static DateTime _toDate(dynamic v) =>
      v != null ? DateTime.parse(v) : DateTime.now();

  factory MyVoucherItem.fromJson(Map<String, dynamic> json) {
    return MyVoucherItem(
      voucherItemId: _toInt(json['voucherItemId']),
      voucherId: _toInt(json['voucherId']),
      voucherTitle: json['voucherTitle'] ?? '',
      itemCode: json['itemCode'] ?? '',
      qrCodeUrl: json['qrCodeUrl'] ?? '',
      status: json['status'] ?? '',
      acquiredAt: _toDate(json['acquiredAt']),
      expiredAt: _toDate(json['expiredAt']),
      usedAt: json['usedAt'] != null ? DateTime.parse(json['usedAt']) : null,
      discountType: json['discountType'],
      discountAmount: (json['discountAmount'] as num?)?.toInt(),
      discountPercent: _toDouble(json['discountPercent']),
    );
  }

  ///  Helper hiển thị discount
  String get discountText {
    if (discountType == "PERCENTAGE" && discountPercent != null) {
      return "-${discountPercent!.toStringAsFixed(0)}%";
    }
    if (discountType == "FIXED_AMOUNT" && discountAmount != null) {
      return "-${discountAmount}";
    }
    return "";
  }

  ///  trạng thái dùng cho UI
  bool get isUsed => status == "USED";
  bool get isExpired => status == "EXPIRED";
  bool get isActive => status == "ACQUIRED";
}
