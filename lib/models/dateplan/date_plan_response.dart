class DatePlanPageResult {
  final DatePlanResponse pagedResult;
  final int totalUpcoming;

  DatePlanPageResult({required this.pagedResult, required this.totalUpcoming});
  factory DatePlanPageResult.fromJson(Map<String, dynamic> json) {
    return DatePlanPageResult(
      pagedResult: DatePlanResponse.fromJson(json['pagedResult']),
      totalUpcoming: json['totalUpcoming'],
    );
  }
}

class DatePlanResponse {
  final List<DatePlanDetails> items;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  DatePlanResponse({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory DatePlanResponse.fromJson(Map<String, dynamic> json) {
    return DatePlanResponse(
      items: (json['items'] as List)
          .map((e) => DatePlanDetails.fromJson(e))
          .toList(),
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalCount: json['totalCount'],
      totalPages: json['totalPages'],
      hasPreviousPage: json['hasPreviousPage'],
      hasNextPage: json['hasNextPage'],
    );
  }
}

class DatePlanDetails {
  final int id;
  final String title;
  final int? version;
  final String plannedStartAt;
  final String plannedEndAt;
  final double estimatedBudget;
  final String status;
  final String? note;

  DatePlanDetails({
    required this.id,
    required this.title,
    required this.version,
    required this.plannedStartAt,
    required this.plannedEndAt,
    required this.estimatedBudget,
    required this.status,
    this.note,
  });

  factory DatePlanDetails.fromJson(Map<String, dynamic> json) {
    return DatePlanDetails(
      id: json['id'],
      title: json['title'],
      version: json['version'],
      plannedStartAt: json['plannedStartAt'],
      plannedEndAt: json['plannedEndAt'],
      estimatedBudget: json['estimatedBudget'].toDouble(),
      status: json['status'],
      note: json['note'],
    );
  }
}
