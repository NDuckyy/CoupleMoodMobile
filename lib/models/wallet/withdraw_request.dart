class WithdrawRequest {
  final int id;
  final int walletId;
  final int amount;
  final BankInfo bankInfo;
  final String status;
  final String? rejectionReason;
  final String? proofImageUrl;
  final DateTime requestedAt;

  WithdrawRequest({
    required this.id,
    required this.walletId,
    required this.amount,
    required this.bankInfo,
    required this.status,
    this.rejectionReason,
    this.proofImageUrl,
    required this.requestedAt,
  });

  factory WithdrawRequest.fromJson(Map<String, dynamic> json) {
    return WithdrawRequest(
      id: json['id'],
      walletId: json['walletId'],
      amount: json['amount'],
      bankInfo: BankInfo.fromJson(json['bankInfo']),
      status: json['status'],
      rejectionReason: json['rejectionReason'],
      proofImageUrl: json['proofImageUrl'],
      requestedAt: DateTime.parse(json['requestedAt']),
    );
  }
}

class BankInfo {
  final String bankName;
  final String accountNumber;
  final String accountName;

  BankInfo({
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
  });

  factory BankInfo.fromJson(Map<String, dynamic> json) {
    return BankInfo(
      bankName: json['bankName'],
      accountNumber: json['accountNumber'],
      accountName: json['accountName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "bankName": bankName,
      "accountNumber": accountNumber,
      "accountName": accountName,
    };
  }
}
