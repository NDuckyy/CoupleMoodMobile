class MemberSubscription {
  final int id;
  final int packageId;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;

  MemberSubscription({
    required this.id,
    required this.packageId,
    required this.status,
    this.startDate,
    this.endDate,
  });

  factory MemberSubscription.fromJson(Map<String, dynamic> json) {
    return MemberSubscription(
      id: json['id'],
      packageId: json['packageId'],
      status: json['status'],
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }

  /// tiện dùng
  bool get isActive => status == "ACTIVE";

  bool get isExpired {
    if (endDate == null) return false;
    return endDate!.isBefore(DateTime.now());
  }
}
