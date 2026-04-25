class WalletTransaction {
  final int transactionId;
  final num amount;
  final String? currency;
  final String? paymentMethod;
  final String? transactionType;
  final String? description;
  final String? status;
  final DateTime? createdAt;
  final String? direction;
  final num? balanceChange;

  WalletTransaction({
    required this.transactionId,
    required this.amount,
    this.currency,
    this.paymentMethod,
    this.transactionType,
    this.description,
    this.status,
    this.createdAt,
    this.direction,
    this.balanceChange,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      transactionId: json['transactionId'] ?? 0,
      amount: json['amount'] ?? 0,
      currency: json['currency'],
      paymentMethod: json['paymentMethod'],
      transactionType: json['transactionType'],
      description: json['description'] ?? '',
      status: json['status'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      direction: json['direction'],
      balanceChange: json['balanceChange'],
    );
  }
}
