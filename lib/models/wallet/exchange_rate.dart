class ExchangeRate {
  final int moneyAmount;
  final int pointAmount;
  final String description;

  ExchangeRate({
    required this.moneyAmount,
    required this.pointAmount,
    required this.description,
  });

  factory ExchangeRate.fromJson(Map<String, dynamic> json) {
    return ExchangeRate(
      moneyAmount: json['moneyAmount'],
      pointAmount: json['pointAmount'],
      description: json['description'] ?? '',
    );
  }
}
