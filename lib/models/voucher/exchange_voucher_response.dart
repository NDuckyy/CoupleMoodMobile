import 'package:couple_mood_mobile/models/voucher/exchange_voucher_item.dart';

class ExchangeVoucherResponse {
  final int voucherItemMemberId;
  final int memberId;
  final int totalQuantityExchanged;
  final int totalPointsUsed;
  final int remainingPoints;
  final DateTime createdAt;
  final List<ExchangeVoucherItem> voucherItems;

  ExchangeVoucherResponse({
    required this.voucherItemMemberId,
    required this.memberId,
    required this.totalQuantityExchanged,
    required this.totalPointsUsed,
    required this.remainingPoints,
    required this.createdAt,
    required this.voucherItems,
  });

  factory ExchangeVoucherResponse.fromJson(Map<String, dynamic> json) {
    return ExchangeVoucherResponse(
      voucherItemMemberId: (json['voucherItemMemberId'] as num?)?.toInt() ?? 0,
      memberId: (json['memberId'] as num?)?.toInt() ?? 0,
      totalQuantityExchanged:
          (json['totalQuantityExchanged'] as num?)?.toInt() ?? 0,
      totalPointsUsed: (json['totalPointsUsed'] as num?)?.toInt() ?? 0,
      remainingPoints: (json['remainingPoints'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      voucherItems: (json['voucherItems'] as List? ?? [])
          .map((e) => ExchangeVoucherItem.fromJson(e))
          .toList(),
    );
  }
}
