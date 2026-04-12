class ShareLinkModel {
  final String shareCode;
  final String shareLinkUrl;

  ShareLinkModel({required this.shareCode, required this.shareLinkUrl});

  factory ShareLinkModel.fromJson(Map<String, dynamic> json) {
    return ShareLinkModel(
      shareCode: json['shareCode'],
      shareLinkUrl: json['shareLinkUrl'],
    );
  }
}
