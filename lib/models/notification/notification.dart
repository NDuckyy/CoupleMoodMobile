class NotificationApp {
  final int id;
  final String title;
  final String message;
  final String type;
  final int? referenceId;
  final String? referenceType;
  bool isRead;
  final DataReview? data;
  final DateTime createdAt;

  NotificationApp({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.referenceId,
    this.referenceType,
    required this.isRead,
    this.data,
    required this.createdAt,
  });

  factory NotificationApp.fromJson(Map<String, dynamic> json) {
    return NotificationApp(
      id: json['id'] as int,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      referenceId: json['referenceId'] as int?,
      referenceType: json['referenceType'] as String?,
      isRead: json['isRead'] as bool,
      data: json['data'] != null && (json['data'] as Map).isNotEmpty
          ? DataReview.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class NotificationPagination {
  final List<NotificationApp> items;
  int pageNumber;
  final int pageSize;
  final int totalPages;
  final int totalCount;
  final bool hasNextPage;
  final bool hasPreviousPage;

  NotificationPagination({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.totalCount,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory NotificationPagination.fromJson(Map<String, dynamic> json) {
    return NotificationPagination(
      items: (json['items'] as List<dynamic>)
          .map((n) => NotificationApp.fromJson(n as Map<String, dynamic>))
          .toList(),
      pageNumber: json['pageNumber'] as int,
      pageSize: json['pageSize'] as int,
      totalPages: json['totalPages'] as int,
      totalCount: json['totalCount'] as int,
      hasNextPage: json['hasNextPage'] as bool,
      hasPreviousPage: json['hasPreviousPage'] as bool,
    );
  }
}

class DataReview {
  final String venueLocationId;

  DataReview({required this.venueLocationId});

  factory DataReview.fromJson(Map<String, dynamic> json) {
    return DataReview(venueLocationId: json['venueLocationId'] as String);
  }
}
