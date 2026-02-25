class ItemRequest {
  final int venueLocationId;
  final String? startTime;
  final String? endTime;
  final String? note;

  ItemRequest({
    required this.venueLocationId,
    this.startTime,
    this.endTime,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'venueLocationId': venueLocationId,
      if (startTime != null) 'startTime': startTime,
      if (endTime != null) 'endTime': endTime,
      if (note != null) 'note': note,
    };
  }
}

class DatePlanItemRequest {
  final List<ItemRequest> items;

  DatePlanItemRequest({required this.items});

  Map<String, dynamic> toJson() {
    return {'venues': items.map((item) => item.toJson()).toList()};
  }
}
