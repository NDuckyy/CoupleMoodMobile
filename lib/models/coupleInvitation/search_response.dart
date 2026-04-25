class SearchResponse<T> {
  final List<T>? data;
  final Pagination pagination;
  final int? pendingCount;

  SearchResponse({required this.data, required this.pagination, this.pendingCount});

  factory SearchResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return SearchResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => fromJson(item as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
      pendingCount: json['pendingCount'] as int?,
    );
  }
}

class Pagination {
  final int page;
  final int pageSize;
  final int total;

  Pagination({required this.page, required this.pageSize, required this.total});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'],
      pageSize: json['pageSize'],
      total: json['total'],
    );
  }
}
