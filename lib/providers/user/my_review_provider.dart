import 'package:flutter/material.dart';
import '../../models/venue/venue_review.dart';
import '../../services/venue/venue_review_service.dart';

class MyReviewProvider extends ChangeNotifier {
  final List<VenueReview> _reviews = [];

  List<VenueReview> get reviews => _reviews;

  bool isLoading = false;
  bool isLoadingMore = false;

  int page = 1;
  bool hasNextPage = true;

  Future<void> fetchInitial() async {
    _reviews.clear();
    page = 1;
    hasNextPage = true;

    isLoading = true;
    notifyListeners();

    try {
      final res = await VenueReviewService.getMyReviews(page: page);

      if (res.data != null) {
        _reviews.addAll(res.data!.items);
        hasNextPage = res.data!.hasNextPage;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (!hasNextPage || isLoadingMore) return;

    isLoadingMore = true;
    notifyListeners();

    try {
      page++;

      final res = await VenueReviewService.getMyReviews(page: page);

      if (res.data != null) {
        _reviews.addAll(res.data!.items);
        hasNextPage = res.data!.hasNextPage;
      }
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await fetchInitial();
  }

  Future<bool> deleteReview(int reviewId) async {
    try {
      final res = await VenueReviewService.deleteReview(reviewId);

      if (res.code == 200) {
        _reviews.removeWhere((e) => e.id == reviewId);
        notifyListeners();
        return true;
      } else {
        throw res.message ?? "Xoá thất bại";
      }
    } catch (e) {
      rethrow;
    }
  }
}
