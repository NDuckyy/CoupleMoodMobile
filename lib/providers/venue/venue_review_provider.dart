import 'package:couple_mood_mobile/models/venue/review_request.dart';
import 'package:flutter/material.dart';
import 'package:couple_mood_mobile/models/venue/venue_review.dart';
import 'package:couple_mood_mobile/models/venue/venue_review_summary.dart';
import 'package:couple_mood_mobile/services/venue/venue_review_service.dart';
import 'package:couple_mood_mobile/models/paginated_response.dart';

class VenueReviewProvider extends ChangeNotifier {
  VenueReviewSummary? summary;
  PaginatedResponse<VenueReview>? pagination;

  bool loading = false;
  String? error;

  List<VenueReview> get reviews => pagination?.items ?? [];
  bool get hasNextPage => pagination?.hasNextPage ?? false;
  int get currentPage => pagination?.pageNumber ?? 1;
  int get totalPages => pagination?.totalPages ?? 1;

  Future<void> loadPage({required int venueId, int page = 1}) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final res = await VenueReviewService.getVenueReviews(
        venueId: venueId,
        page: page,
      );

      if (res.code == 200 && res.data != null) {
        summary = res.data!.summary;
        pagination = res.data!.reviews;
      } else {
        error = res.message;
      }
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> submitReview(ReviewRequest request) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final res = await VenueReviewService.submitVenueReview(request);

      if (res.code != 200) {
        error = res.message;
      }
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
