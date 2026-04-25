import 'package:couple_mood_mobile/models/voucher/exchange_item.dart';

class ExchangeVoucherRequest {
  final List<ExchangeItem> items;
  final String? note;

  ExchangeVoucherRequest({required this.items, this.note});

  Map<String, dynamic> toJson() => {
    'items': items.map((e) => e.toJson()).toList(),
    'note': note,
  };
}
