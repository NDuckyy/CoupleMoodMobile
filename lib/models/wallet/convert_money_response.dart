class ConvertMoneyResponse {
  final int transactionId;
  final num convertedMoney;
  final num convertedPoints;
  final num balanceBefore;
  final num balanceAfter;
  final num pointsBefore;
  final num pointsAfter;
  final num rate;

  ConvertMoneyResponse({
    required this.transactionId,
    required this.convertedMoney,
    required this.convertedPoints,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.pointsBefore,
    required this.pointsAfter,
    required this.rate,
  });

  factory ConvertMoneyResponse.fromJson(Map<String, dynamic> json) {
    return ConvertMoneyResponse(
      transactionId: json['transactionId'] ?? 0,
      convertedMoney: json['convertedMoney'] ?? 0,
      convertedPoints: json['convertedPoints'] ?? 0,
      balanceBefore: json['balanceBefore'] ?? 0,
      balanceAfter: json['balanceAfter'] ?? 0,
      pointsBefore: json['pointsBefore'] ?? 0,
      pointsAfter: json['pointsAfter'] ?? 0,
      rate: json['rate'] ?? 0,
    );
  }
}
