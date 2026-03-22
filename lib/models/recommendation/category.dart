class CategoryPagination {
  final List<CategoryItem> items;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  CategoryPagination({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory CategoryPagination.fromJson(Map<String, dynamic> json) {
    var itemsJson = json['items'] as List<dynamic>? ?? [];
    List<CategoryItem> itemsList = itemsJson
        .map((itemJson) => CategoryItem.fromJson(itemJson))
        .toList();

    return CategoryPagination(
      items: itemsList,
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalCount: json['totalCount'],
      totalPages: json['totalPages'],
      hasNextPage: json['hasNextPage'],
      hasPreviousPage: json['hasPreviousPage'],
    );
  }
}

class CategoryItem {
  final int id;
  final String name;
  final String? description;

  CategoryItem({required this.id, required this.name, this.description});

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
