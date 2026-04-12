class ZaloPaymentData {
  final int returnCode;
  final String returnMessage;
  final int subReturnCode;
  final String subReturnMessage;
  final String orderUrl;
  final String zpTransToken;
  final String orderToken;
  final String? qrCode;

  ZaloPaymentData({
    required this.returnCode,
    required this.returnMessage,
    required this.subReturnCode,
    required this.subReturnMessage,
    required this.orderUrl,
    required this.zpTransToken,
    required this.orderToken,
    this.qrCode,
  });

  factory ZaloPaymentData.fromJson(Map<String, dynamic> json) {
    return ZaloPaymentData(
      returnCode: json['return_code'] ?? 0,
      returnMessage: json['return_message'] ?? '',
      subReturnCode: json['sub_return_code'] ?? 0,
      subReturnMessage: json['sub_return_message'] ?? '',
      orderUrl: json['order_url'] ?? '',
      zpTransToken: json['zp_trans_token'] ?? '',
      orderToken: json['order_token'] ?? '',
      qrCode: json['qr_code'],
    );
  }
}
