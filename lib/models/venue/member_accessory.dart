class MemberAccessory {
  final int? memberAccessoryId;
  final int accessoryId;
  final String code;
  final String name;
  final String type;

  final String? thumbnailUrl;
  final String? resourceUrl;

  // Shop fields
  final int? pricePoint;
  final bool? isLimited;
  final int? totalQuantity;
  final int? remainingQuantity;
  final String? status;
  final bool? canPurchase;

  // User state
  final bool? isOwnedByMe;
  final bool? isOwnedByPartner;
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
    this.canPurchase,
    this.isOwnedByMe,
    this.isOwnedByPartner,
    this.isEquipped,
  });

  factory MemberAccessory.empty() {
    return MemberAccessory(
      memberAccessoryId: 0,
      accessoryId: 0,
      code: '',
      name: '',
      type: '',
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
      canPurchase: json['canPurchase'],
      isOwnedByMe: json['isOwnedByMe'],
      isOwnedByPartner: json['isOwnedByPartner'],
      isEquipped: json['isEquipped'],
    );
  }

  // ==================== COPY WITH ====================
  MemberAccessory copyWith({
    int? memberAccessoryId,
    int? accessoryId,
    String? code,
    String? name,
    String? type,
    String? thumbnailUrl,
    String? resourceUrl,
    int? pricePoint,
    bool? isLimited,
    int? totalQuantity,
    int? remainingQuantity,
    String? status,
    bool? canPurchase,
    bool? isOwnedByMe,
    bool? isOwnedByPartner,
    bool? isEquipped,
  }) {
    return MemberAccessory(
      memberAccessoryId: memberAccessoryId ?? this.memberAccessoryId,
      accessoryId: accessoryId ?? this.accessoryId,
      code: code ?? this.code,
      name: name ?? this.name,
      type: type ?? this.type,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      resourceUrl: resourceUrl ?? this.resourceUrl,
      pricePoint: pricePoint ?? this.pricePoint,
      isLimited: isLimited ?? this.isLimited,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      remainingQuantity: remainingQuantity ?? this.remainingQuantity,
      status: status ?? this.status,
      canPurchase: canPurchase ?? this.canPurchase,
      isOwnedByMe: isOwnedByMe ?? this.isOwnedByMe,
      isOwnedByPartner: isOwnedByPartner ?? this.isOwnedByPartner,
      isEquipped: isEquipped ?? this.isEquipped,
    );
  }
}
