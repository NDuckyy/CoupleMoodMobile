import 'package:couple_mood_mobile/models/recommendation/recommendation.dart';

class RecommendationPage {
  List<Recommendation> items;
  int pageNumber;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  bool hasPreviousPage;
  bool hasNextPage;

  RecommendationPage({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory RecommendationPage.fromJson(Map<String, dynamic> json) {
    return RecommendationPage(
      items: (json['items'] as List)
          .map((item) => Recommendation.fromJson(item))
          .toList(),
      pageNumber: json['pageNumber'] as int,
      pageSize: json['pageSize'] as int,
      totalCount: json['totalCount'] as int,
      totalPages: json['totalPages'] as int,
      hasPreviousPage: json['hasPreviousPage'] as bool,
      hasNextPage: json['hasNextPage'] as bool,
    );
  }
}
