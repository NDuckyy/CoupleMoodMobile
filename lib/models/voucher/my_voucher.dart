class MyVoucherItem {
  final int voucherItemId;
  final int voucherId;
  final String voucherTitle;
  final String voucherDescription;
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
    required this.voucherDescription,
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

  factory MyVoucherItem.fromJson(Map<String, dynamic> json) {
    return MyVoucherItem(
      voucherItemId: json['voucherItemId'],
      voucherId: json['voucherId'],
      voucherTitle: json['voucherTitle'],
      voucherDescription: json['voucherDescription'],
      itemCode: json['itemCode'],
      qrCodeUrl: json['qrCodeUrl'],
      status: json['status'],
      acquiredAt: DateTime.parse(json['acquiredAt']),
      expiredAt: DateTime.parse(json['expiredAt']),
      usedAt: json['usedAt'] != null ? DateTime.parse(json['usedAt']) : null,
      discountType: json['discountType'],
      discountAmount: json['discountAmount'],
      discountPercent: (json['discountPercent'] != null)
          ? json['discountPercent'].toDouble()
          : null,
    );
  }
}
