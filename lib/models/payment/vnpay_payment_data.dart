class VnpayPaymentData {
  final String payUrl;

  VnpayPaymentData({required this.payUrl});

  factory VnpayPaymentData.fromJson(Map<String, dynamic> json) {
    return VnpayPaymentData(payUrl: json['payUrl'] ?? '');
  }
}
