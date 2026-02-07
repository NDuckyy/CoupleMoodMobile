class DatePlanCreateAndUpdateRequest {
  final String title;
  final String note;
  final DateTime plannedStartAt;
  final DateTime plannedEndAt;
  final double estimatedBudget;
  final int? version;

  DatePlanCreateAndUpdateRequest({
    required this.title,
    required this.note,
    required this.plannedStartAt,
    required this.plannedEndAt,
    required this.estimatedBudget,
    this.version,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'note': note,
      'plannedStartAt': plannedStartAt.toIso8601String(),
      'plannedEndAt': plannedEndAt.toIso8601String(),
      'estimatedBudget': estimatedBudget,
      if (version != null) 'version': version,
    };
  }
}