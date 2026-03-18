import 'package:couple_mood_mobile/models/voucher/member_voucher_item.dart';

class MemberVoucherTransaction {
  final int id;
  final int memberId;
  final int quantity;
  final int totalPointsUsed;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int voucherTypeCount;
  final List<String> voucherTitles;
  final List<MemberVoucherItem>? voucherItems; // chi tiết nếu cần

  MemberVoucherTransaction({
    required this.id,
    required this.memberId,
    required this.quantity,
    required this.totalPointsUsed,
    this.note,
    required this.createdAt,
    required this.updatedAt,
    required this.voucherTypeCount,
    required this.voucherTitles,
    this.voucherItems,
  });

  factory MemberVoucherTransaction.fromJson(Map<String, dynamic> json) {
    DateTime _parseDate(String? value) => value == null
        ? DateTime.now()
        : DateTime.tryParse(value) ?? DateTime.now();

    return MemberVoucherTransaction(
      id: (json['id'] as num?)?.toInt() ?? 0,
      memberId: (json['memberId'] as num?)?.toInt() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      totalPointsUsed: (json['totalPointsUsed'] as num?)?.toInt() ?? 0,
      note: json['note'],
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      voucherTypeCount: (json['voucherTypeCount'] as num?)?.toInt() ?? 0,
      voucherTitles: (json['voucherTitles'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      voucherItems: json['voucherItems'] != null
          ? (json['voucherItems'] as List)
                .map((e) => MemberVoucherItem.fromJson(e))
                .toList()
          : null,
    );
  }
}
