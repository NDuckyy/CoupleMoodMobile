class SubscriptionPackage {
  final int id;
  final String packageName;
  final double price;
  final int durationDays;
  final String type;
  final String? description;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SubscriptionPackage({
    required this.id,
    required this.packageName,
    required this.price,
    required this.durationDays,
    required this.type,
    this.description,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory SubscriptionPackage.fromJson(Map<String, dynamic> json) {
    return SubscriptionPackage(
      id: json['id'],
      packageName: json['packageName'],
      price: (json['price'] as num).toDouble(),
      durationDays: json['durationDays'],
      type: json['type'],
      description: json['description'],
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }
}
