class AppliedFilters {
  final String locationType;
  final int radiusKm;
  final int budgetLevel;

  AppliedFilters({
    required this.locationType,
    required this.radiusKm,
    required this.budgetLevel,
  });

  factory AppliedFilters.fromJson(Map<String, dynamic> json) {
    return AppliedFilters(
      locationType: json['locationType'],
      radiusKm: json['radiusKm'],
      budgetLevel: json['budgetLevel'],
    );
  }
}
