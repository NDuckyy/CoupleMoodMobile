import 'package:couple_mood_mobile/models/voucher/voucher_location.dart';
import 'package:couple_mood_mobile/utils/currency_utils.dart';

class MemberVoucherItem {
  final int voucherItemId;
  final int voucherId;
  final String voucherTitle;
  final String? voucherDescription;
  final String itemCode;
  final String qrCodeUrl;
  final String? imageUrl;
  final String status;
  final DateTime acquiredAt;
  final DateTime expiredAt;
  final DateTime? usedAt;
  final String? discountType;
  final int? discountAmount;
  final double? discountPercent;

  final List<VoucherLocation> locations;

  MemberVoucherItem({
    required this.voucherItemId,
    required this.voucherId,
    required this.voucherTitle,
    this.voucherDescription,
    required this.itemCode,
    required this.qrCodeUrl,
    this.imageUrl,
    required this.status,
    required this.acquiredAt,
    required this.expiredAt,
    this.usedAt,
    this.discountType,
    this.discountAmount,
    this.discountPercent,
    required this.locations,
  });

  bool get isUsed => status == "USED";

  bool get isExpired =>
      status == "EXPIRED" || expiredAt.isBefore(DateTime.now());

  bool get isAvailable => status == "ACQUIRED" && !isExpired;

  String get discountText {
    if (discountType == "PERCENTAGE") {
      return "-${discountPercent?.toStringAsFixed(0) ?? 0}%";
    }
    if (discountType == "FIXED_AMOUNT") {
      return "${CurrencyUtils.formatVND(discountAmount!)} GIẢM";
    }
    return "";
  }

  factory MemberVoucherItem.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDate(String? value) =>
        value == null ? null : DateTime.tryParse(value);

    List<VoucherLocation> _parseLocations(dynamic data) {
      if (data is List) {
        return data.map((e) => VoucherLocation.fromJson(e)).toList();
      }
      return [];
    }

    return MemberVoucherItem(
      voucherItemId: (json['voucherItemId'] as num?)?.toInt() ?? 0,
      voucherId: (json['voucherId'] as num?)?.toInt() ?? 0,
      voucherTitle: json['voucherTitle'] ?? '',
      voucherDescription: json['voucherDescription'],
      itemCode: json['itemCode'] ?? '',
      qrCodeUrl: json['qrCodeUrl'] ?? '',
      imageUrl: json['imageUrl'] as String?,
      status: json['status'] ?? '',
      acquiredAt: _parseDate(json['acquiredAt']) ?? DateTime.now(),
      expiredAt: _parseDate(json['expiredAt']) ?? DateTime.now(),
      usedAt: _parseDate(json['usedAt']),
      discountType: json['discountType'],
      discountAmount: (json['discountAmount'] as num?)?.toInt(),
      discountPercent: (json['discountPercent'] as num?)?.toDouble(),
      locations: _parseLocations(json['locations']),
    );
  }
}
