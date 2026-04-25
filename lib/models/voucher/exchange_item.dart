class ExchangeItem {
  final int voucherId;
  final int quantity;

  ExchangeItem({required this.voucherId, required this.quantity});

  Map<String, dynamic> toJson() => {
    'voucherId': voucherId,
    'quantity': quantity,
  };
}
