class AiDatePlanItemRequest {
  final String query;
  final DateTime plannedStartAt;
  final DateTime plannedEndAt;
  final String durationMode;
  final double latitude;
  final double longitude;
  final double estimatedBudget;

  AiDatePlanItemRequest({
    required this.query,
    required this.plannedStartAt,
    required this.plannedEndAt,
    required this.durationMode,
    required this.latitude,
    required this.longitude,
    required this.estimatedBudget,
  });

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'plannedStartAt': plannedStartAt.toIso8601String(),
      'plannedEndAt': plannedEndAt.toIso8601String(),
      'durationMode': durationMode,
      'latitude': latitude,
      'longitude': longitude,
      'estimatedBudget': estimatedBudget,
    };
  }
}