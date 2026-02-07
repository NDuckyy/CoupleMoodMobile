import 'venue_review_summary.dart';
import 'venue_review_pagination.dart';

class VenueReviewData {
  final VenueReviewSummary summary;
  final VenueReviewPagination reviews;

  VenueReviewData({required this.summary, required this.reviews});

  factory VenueReviewData.fromJson(Map<String, dynamic> json) {
    return VenueReviewData(
      summary: VenueReviewSummary.fromJson(json['summary']),
      reviews: VenueReviewPagination.fromJson(json['reviews']),
    );
  }
}
