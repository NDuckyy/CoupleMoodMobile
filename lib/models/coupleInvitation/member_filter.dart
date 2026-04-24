class MemberFilter {
  int? ageFrom;
  int? ageTo;
  int? heightFrom;
  int? heightTo;
  int? weightFrom;
  int? weightTo;
  String? city;
  String? district;

  MemberFilter({
    this.ageFrom,
    this.ageTo,
    this.heightFrom,
    this.heightTo,
    this.weightFrom,
    this.weightTo,
    this.city,
    this.district,
  });

  Map<String, dynamic> toQuery() {
    return {
      if (ageFrom != null) "ageFrom": ageFrom,
      if (ageTo != null) "ageTo": ageTo,
      if (heightFrom != null) "heightFrom": heightFrom,
      if (heightTo != null) "heightTo": heightTo,
      if (weightFrom != null) "weightFrom": weightFrom,
      if (weightTo != null) "weightTo": weightTo,
      if (city != null) "city": city,
      if (district != null) "district": district,
    };
  }
}
