class MemberAccessory {
  final int? memberAccessoryId; // nullable
  final int accessoryId;
  final String code;
  final String name;
  final String type;

  final String? thumbnailUrl;
  final String? resourceUrl;

  //  shop fields
  final int? pricePoint;
  final bool? isLimited;
  final int? totalQuantity;
  final int? remainingQuantity;
  final String? status;
  final bool? isOwnedByMe;
  final bool? isOwnedByPartner;
  final bool? canPurchase;
  final bool? isEquipped;

  MemberAccessory({
    this.memberAccessoryId,
    required this.accessoryId,
    required this.code,
    required this.name,
    required this.type,
    this.thumbnailUrl,
    this.resourceUrl,

    this.pricePoint,
    this.isLimited,
    this.totalQuantity,
    this.remainingQuantity,
    this.status,
    this.isOwnedByMe,
    this.isOwnedByPartner,
    this.canPurchase,
    this.isEquipped,
  });

  factory MemberAccessory.empty() {
    return MemberAccessory(
      memberAccessoryId: 0,
      accessoryId: 0,
      code: '',
      name: '',
      type: '',
      thumbnailUrl: null,
      resourceUrl: null,
    );
  }

  factory MemberAccessory.fromJson(Map<String, dynamic> json) {
    return MemberAccessory(
      memberAccessoryId: json['memberAccessoryId'],
      accessoryId: json['accessoryId'] ?? 0,
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      thumbnailUrl: json['thumbnailUrl'],
      resourceUrl: json['resourceUrl'],

      pricePoint: json['pricePoint'],
      isLimited: json['isLimited'],
      totalQuantity: json['totalQuantity'],
      remainingQuantity: json['remainingQuantity'],
      status: json['status'],
      isOwnedByMe: json['isOwnedByMe'],
      isOwnedByPartner: json['isOwnedByPartner'],
      canPurchase: json['canPurchase'],
      isEquipped: json['isEquipped'],
    );
  }
}
