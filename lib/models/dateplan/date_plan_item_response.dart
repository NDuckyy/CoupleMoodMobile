import 'package:couple_mood_mobile/models/dateplan/venue_location.dart';

class DatePlanItemResponse {
  final List<ListDatePlanItem> items;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  DatePlanItemResponse({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory DatePlanItemResponse.fromJson(Map<String, dynamic> json) {
    return DatePlanItemResponse(
      items: (json['items'] as List)
          .map((e) => ListDatePlanItem.fromJson(e))
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

class ListDatePlanItem {
  final int id;
  final int datePlanId;
  final int venueLocationId;
  final VenueLocation venueLocation;
  final int orderIndex;
  final String startTime;
  final String endTime;
  final String note;
  final String? visitedAt;
  final String? skippedAt;

  ListDatePlanItem({
    required this.id,
    required this.datePlanId,
    required this.venueLocationId,
    required this.venueLocation,
    required this.orderIndex,
    required this.startTime,
    required this.endTime,
    required this.note,
    this.visitedAt,
    this.skippedAt,
  });

  factory ListDatePlanItem.fromJson(Map<String, dynamic> json) {
    return ListDatePlanItem(
      id: json['id'],
      datePlanId: json['datePlanId'],
      venueLocationId: json['venueLocationId'],
      venueLocation: VenueLocation.fromJson(json['venueLocation']),
      orderIndex: json['orderIndex'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      note: json['note'],
      visitedAt: json['visitedAt'],
      skippedAt: json['skippedAt'],
    );
  }
}
