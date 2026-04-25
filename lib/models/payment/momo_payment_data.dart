class MomoPaymentData {
  final String payUrl;
  final String deepLink;
  final String qrCodeUrl;
  final String deeplinkMiniApp;

  MomoPaymentData({
    required this.payUrl,
    required this.deepLink,
    required this.qrCodeUrl,
    required this.deeplinkMiniApp,
  });

  factory MomoPaymentData.fromJson(Map<String, dynamic> json) {
    return MomoPaymentData(
      payUrl: json['payUrl'] ?? '',
      deepLink: json['deepLink'] ?? '',
      qrCodeUrl: json['qrCodeUrl'] ?? '',
      deeplinkMiniApp: json['deeplinkMiniApp'] ?? '',
    );
  }
}
