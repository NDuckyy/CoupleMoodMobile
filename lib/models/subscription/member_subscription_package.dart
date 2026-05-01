class MemberActiveSubscription {
  final bool hasActiveSubscription;
  final int? subscriptionId;
  final int? packageId;
  final String? packageName;
  final DateTime? startDate;
  final DateTime? endDate;

  MemberActiveSubscription({
    required this.hasActiveSubscription,
    this.subscriptionId,
    this.packageId,
    this.packageName,
    this.startDate,
    this.endDate,
  });

  factory MemberActiveSubscription.fromJson(Map<String, dynamic> json) {
    return MemberActiveSubscription(
      hasActiveSubscription: json['hasActiveSubscription'] ?? false,
      subscriptionId: json['subscriptionId'],
      packageId: json['packageId'],
      packageName: json['packageName'],
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }
}
