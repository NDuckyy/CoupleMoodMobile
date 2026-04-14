class TestHistory {
  final int id;
  final int testTypeId;
  final String? resultCode;
  final String status;
  final String? takenAt;

  TestHistory({
    required this.id,
    required this.testTypeId,
    this.resultCode,
    required this.status,
    this.takenAt,
  });

  factory TestHistory.fromJson(Map<String, dynamic> json) {
    return TestHistory(
      id: json['id'],
      testTypeId: json['testTypeId'],
      resultCode: json['resultCode'],
      status: json['status'],
      takenAt: json['takenAt'],
    );
  }
}

class TestHistoryPagination {
  final List<TestHistory> items;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  TestHistoryPagination({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory TestHistoryPagination.fromJson(Map<String, dynamic> json) {
    return TestHistoryPagination(
      items: (json['items'] as List)
          .map((e) => TestHistory.fromJson(e))
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
