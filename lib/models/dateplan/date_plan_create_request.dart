class DatePlanCreateAndUpdateRequest {
  final String title;
  final String note;
  final DateTime plannedStartAt;
  final DateTime plannedEndAt;
  final double estimatedBudget;
  final String? durationMode;
  final int? version;

  DatePlanCreateAndUpdateRequest({
    required this.title,
    required this.note,
    required this.plannedStartAt,
    required this.plannedEndAt,
    required this.estimatedBudget,
    this.durationMode,
    this.version,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'note': note,
      'plannedStartAt': plannedStartAt.toIso8601String(),
      'plannedEndAt': plannedEndAt.toIso8601String(),
      'estimatedBudget': estimatedBudget,
      if (durationMode != null) 'durationMode': durationMode,
      if (version != null) 'version': version,
    };
  }
}