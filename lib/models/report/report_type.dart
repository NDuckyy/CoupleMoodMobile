class ReportType {
  final int id;
  final String typeName;
  final String description;
  final bool isActive;

  ReportType({
    required this.id,
    required this.typeName,
    required this.description,
    required this.isActive,
  });

  factory ReportType.fromJson(Map<String, dynamic> json) {
    return ReportType(
      id: json['id'],
      typeName: json['typeName'],
      description: json['description'],
      isActive: json['isActive'],
    );
  }
}
