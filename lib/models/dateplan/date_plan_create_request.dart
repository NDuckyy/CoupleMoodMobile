class DatePlanCreateRequest {
  final String title;
  final String note;
  final DateTime plannedStartAt;
  final DateTime plannedEndAt;
  final double estimatedBudget;

  DatePlanCreateRequest({
    required this.title,
    required this.note,
    required this.plannedStartAt,
    required this.plannedEndAt,
    required this.estimatedBudget,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'note': note,
      'plannedStartAt': plannedStartAt.toIso8601String(),
      'plannedEndAt': plannedEndAt.toIso8601String(),
      'estimatedBudget': estimatedBudget,
    };
  }
}