class SearchHistory {
  final List<SearchHistoryItem> items;

  SearchHistory({required this.items});

  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    var itemsJson = json['items'] as List<dynamic>? ?? [];
    List<SearchHistoryItem> itemsList = itemsJson
        .map((itemJson) => SearchHistoryItem.fromJson(itemJson))
        .toList();

    return SearchHistory(items: itemsList);
  }
}

class SearchHistoryItem {
  final int id;
  final int memberId;
  final String keyword;

  SearchHistoryItem({
    required this.id,
    required this.memberId,
    required this.keyword,
  });

  factory SearchHistoryItem.fromJson(Map<String, dynamic> json) {
    return SearchHistoryItem(
      id: json['id'],
      memberId: json['memberId'],
      keyword: json['keyword'],
    );
  }
}
