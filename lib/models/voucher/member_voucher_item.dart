class MemberVoucherItem {
  final int voucherItemId;
  final int voucherId;
  final String voucherTitle;
  final String? voucherDescription;
  final String itemCode;
  final String qrCodeUrl;
  final String status;
  final DateTime acquiredAt;
  final DateTime expiredAt;
  final DateTime? usedAt;
  final String? discountType;
  final int? discountAmount;
  final double? discountPercent;

  MemberVoucherItem({
    required this.voucherItemId,
    required this.voucherId,
    required this.voucherTitle,
    this.voucherDescription,
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

  factory MemberVoucherItem.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDate(String? value) =>
        value == null ? null : DateTime.tryParse(value);

    return MemberVoucherItem(
      voucherItemId: (json['voucherItemId'] as num?)?.toInt() ?? 0,
      voucherId: (json['voucherId'] as num?)?.toInt() ?? 0,
      voucherTitle: json['voucherTitle'] ?? '',
      voucherDescription: json['voucherDescription'],
      itemCode: json['itemCode'] ?? '',
      qrCodeUrl: json['qrCodeUrl'] ?? '',
      status: json['status'] ?? '',
      acquiredAt: _parseDate(json['acquiredAt']) ?? DateTime.now(),
      expiredAt: _parseDate(json['expiredAt']) ?? DateTime.now(),
      usedAt: _parseDate(json['usedAt']),
      discountType: json['discountType'],
      discountAmount: (json['discountAmount'] as num?)?.toInt(),
      discountPercent: (json['discountPercent'] as num?)?.toDouble(),
    );
  }
}
