import 'package:flutter/material.dart';
import 'package:couple_mood_mobile/models/venue/venue_review.dart';
import 'package:couple_mood_mobile/models/venue/venue_review_summary.dart';
import 'package:couple_mood_mobile/services/venue/venue_review_service.dart';

class VenueReviewProvider extends ChangeNotifier {
  VenueReviewSummary? summary;
  List<VenueReview> reviews = [];

  bool loading = false;

  int currentPage = 1;
  int totalPages = 1;

  Future<void> loadPage({required int venueId, int page = 1}) async {
    loading = true;
    notifyListeners();

    final res = await VenueReviewService.getVenueReviews(
      venueId: venueId,
      page: page,
    );

    if (res.code == 200 && res.data != null) {
      summary = res.data!.summary;
      reviews = res.data!.reviews.items;

      currentPage = res.data!.reviews.pageNumber;
      totalPages = res.data!.reviews.totalPages;
    }

    loading = false;
    notifyListeners();
  }
}
