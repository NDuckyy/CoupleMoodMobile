class PaymentStatus {
  final bool isActive;
  final String? description;
  final double? amount;
  final String? currency;
  final String? paymentMethod;
  final DateTime? startDate;
  final DateTime? endDate;

  final String? status;
  final bool? isSuccess;

  PaymentStatus({
    required this.isActive,
    this.description,
    this.amount,
    this.currency,
    this.paymentMethod,
    this.endDate,
    this.startDate,
    this.status,
    this.isSuccess,
  });

  factory PaymentStatus.fromJson(Map<String, dynamic> json) {
    return PaymentStatus(
      isActive: json['isActive'] ?? false,
      description: json['description'],
      amount: (json['amount'] as num?)?.toDouble(),
      currency: json['currency'],
      paymentMethod: json['paymentMethod'],
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      status: json['status'],
      isSuccess: json['isSuccess'],
    );
  }
}
