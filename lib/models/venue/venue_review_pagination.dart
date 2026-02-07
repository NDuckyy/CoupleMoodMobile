import 'package:couple_mood_mobile/models/venue_review.dart';

class VenueReviewPagination {
  final List<VenueReview> items;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasNextPage;

  VenueReviewPagination({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasNextPage,
  });

  factory VenueReviewPagination.fromJson(Map<String, dynamic> json) {
    return VenueReviewPagination(
      items: (json['items'] as List)
          .map((e) => VenueReview.fromJson(e))
          .toList(),
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalCount: json['totalCount'],
      totalPages: json['totalPages'],
      hasNextPage: json['hasNextPage'],
    );
  }
}
