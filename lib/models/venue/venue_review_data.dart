import 'venue_review_summary.dart';
import 'package:couple_mood_mobile/models/paginated_response.dart';
import 'venue_review.dart';

class VenueReviewData {
  final VenueReviewSummary summary;
  final PaginatedResponse<VenueReview> reviews;

  VenueReviewData({required this.summary, required this.reviews});

  factory VenueReviewData.fromJson(Map<String, dynamic> json) {
    return VenueReviewData(
      summary: VenueReviewSummary.fromJson(json['summary']),
      reviews: PaginatedResponse<VenueReview>.fromJson(
        json['reviews'],
        (e) => VenueReview.fromJson(e),
      ),
    );
  }
}
