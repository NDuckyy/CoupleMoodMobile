class DatePlanInfo {
  final String title;
  final String? note;
  final DateTime plannedStartAt;
  final DateTime plannedEndAt;
  final double? estimatedBudget;
  final String? durationMode;
  final int? version;
  final String? status;

  DatePlanInfo({
    required this.title,
    this.note,
    required this.plannedStartAt,
    required this.plannedEndAt,
    this.estimatedBudget,
    this.durationMode,
    this.version,
    this.status,
  });

  factory DatePlanInfo.fromJson(Map<String, dynamic> json) {
    return DatePlanInfo(
      title: json['title'],
      note: json['note'],
      plannedStartAt: DateTime.parse(json['plannedStartAt']),
      plannedEndAt: DateTime.parse(json['plannedEndAt']),
      estimatedBudget: (json['estimatedBudget'] as num?)?.toDouble(),
      durationMode: json['durationMode'],
      version: json['version'],
      status: json['status'],
    );
  }
}
