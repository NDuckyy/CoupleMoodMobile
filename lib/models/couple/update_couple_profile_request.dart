class UpdateCoupleProfileRequest {
  String? coupleName;
  String? startDate;
  String? aniversaryDate;
  int? budgetMin;
  int? budgetMax;

  UpdateCoupleProfileRequest({
    this.coupleName,
    this.startDate,
    this.aniversaryDate,
    this.budgetMin,
    this.budgetMax,
  });

  Map<String, dynamic> toJson() {
    return {
      if (coupleName != null) "coupleName": coupleName,
      if (startDate != null) "startDate": startDate,
      if (aniversaryDate != null) "aniversaryDate": aniversaryDate,
      if (budgetMin != null) "budgetMin": budgetMin,
      if (budgetMax != null) "budgetMax": budgetMax,
    };
  }
}