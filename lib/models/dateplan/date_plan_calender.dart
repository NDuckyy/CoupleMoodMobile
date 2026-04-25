class DatePlanCalender {
  final String startDay;
  final String endDay;
  final List<DatePlanDay> days;

  DatePlanCalender({
    required this.startDay,
    required this.endDay,
    required this.days,
  });

  factory DatePlanCalender.fromJson(Map<String, dynamic> json) {
    return DatePlanCalender(
      startDay: json['startDay'],
      endDay: json['endDay'],
      days: List<DatePlanDay>.from(
        (json['days'] as List).map((x) => DatePlanDay.fromJson(x)),
      ),
    );
  }
}

class DatePlanDay {
  final String date;
  final bool hasDatePlan;
  final List<int> datePlanIds;

  DatePlanDay({
    required this.date,
    required this.hasDatePlan,
    required this.datePlanIds,
  });

  factory DatePlanDay.fromJson(Map<String, dynamic> json) {
    return DatePlanDay(
      date: json['date'],
      hasDatePlan: json['hasDatePlan'],
      datePlanIds: (json['datePlanIds'] as List?)?.map((e) => e as int).toList() ?? [],
    );
  }
}
