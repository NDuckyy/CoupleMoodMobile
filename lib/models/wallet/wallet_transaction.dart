class WalletTransaction {
  final int transactionId;
  final int amount;
  final String currency;
  final String paymentMethod;
  final String transactionType;
  final String description;
  final String status;
  final DateTime createdAt;
  final String direction;
  final int balanceChange;

  WalletTransaction({
    required this.transactionId,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    required this.transactionType,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.direction,
    required this.balanceChange,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      transactionId: json['transactionId'],
      amount: json['amount'],
      currency: json['currency'],
      paymentMethod: json['paymentMethod'],
      transactionType: json['transactionType'],
      description: json['description'] ?? '',
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      direction: json['direction'],
      balanceChange: json['balanceChange'],
    );
  }
}
