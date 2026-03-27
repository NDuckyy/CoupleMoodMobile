class ConvertMoneyResponse {
  final int convertedMoney;
  final int convertedPoints;
  final int balanceBefore;
  final int balanceAfter;
  final int pointsBefore;
  final int pointsAfter;
  final int rate;

  ConvertMoneyResponse({
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
      convertedMoney: json['convertedMoney'],
      convertedPoints: json['convertedPoints'],
      balanceBefore: json['balanceBefore'],
      balanceAfter: json['balanceAfter'],
      pointsBefore: json['pointsBefore'],
      pointsAfter: json['pointsAfter'],
      rate: json['rate'],
    );
  }
}
