class ExchangeVoucherItem {
  final int voucherId;
  final String voucherTitle;
  final String itemCode;
  final String qrCodeUrl;
  final String status;
  final DateTime acquiredAt;
  final DateTime expiredAt;

  ExchangeVoucherItem({
    required this.voucherId,
    required this.voucherTitle,
    required this.itemCode,
    required this.qrCodeUrl,
    required this.status,
    required this.acquiredAt,
    required this.expiredAt,
  });

  factory ExchangeVoucherItem.fromJson(Map<String, dynamic> json) {
    return ExchangeVoucherItem(
      voucherId: (json['voucherId'] as num?)?.toInt() ?? 0,
      voucherTitle: json['voucherTitle'] ?? '',
      itemCode: json['itemCode'] ?? '',
      qrCodeUrl: json['qrCodeUrl'] ?? '',
      status: json['status'] ?? '',
      acquiredAt: DateTime.tryParse(json['acquiredAt'] ?? '') ?? DateTime.now(),
      expiredAt: DateTime.tryParse(json['expiredAt'] ?? '') ?? DateTime.now(),
    );
  }
}
