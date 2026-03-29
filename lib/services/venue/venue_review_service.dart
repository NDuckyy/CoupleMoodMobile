import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/paginated_response.dart';
import 'package:couple_mood_mobile/models/venue/review_request.dart';
import 'package:couple_mood_mobile/models/venue/update_review_request.dart';
import 'package:couple_mood_mobile/models/venue/venue_review.dart';
import 'package:couple_mood_mobile/models/venue/venue_review_data.dart';
import 'package:couple_mood_mobile/services/api_client.dart';

class VenueReviewService {
  static Future<ApiResponse<VenueReviewData>> getVenueReviews({
    required int venueId,
    int page = 1,
    int pageSize = 10,
  }) async {
    final res = await ApiClient.request(
      '/VenueLocation/$venueId/reviews',
      method: HttpMethod.get,
      query: {'page': page, 'pageSize': pageSize},
    );

    return ApiResponse<VenueReviewData>.fromJson(
      res,
      (json) => VenueReviewData.fromJson(json),
    );
  }

  static Future<ApiResponse<void>> submitVenueReview(
    ReviewRequest request,
  ) async {
    final res = await ApiClient.request(
      '/Review/submit',
      method: HttpMethod.post,
      data: request.toJson(),
    );

    return ApiResponse.fromJson(res, (json) {});
  }

  static Future<ApiResponse<Map<String, dynamic>>> toggleLikeReview(
    int reviewId,
  ) async {
    final res = await ApiClient.request(
      '/Review/$reviewId/toggle-like',
      method: HttpMethod.post,
    );

    return ApiResponse<Map<String, dynamic>>.fromJson(
      res,
      (json) => json as Map<String, dynamic>,
    );
  }

  static Future<ApiResponse<PaginatedResponse<VenueReview>>> getMyReviews({
    int page = 1,
    int pageSize = 10,
    int? venueId,
    String? keyword,
    bool sortDescending = true,
  }) async {
    final res = await ApiClient.request(
      '/Review/my-reviews',
      method: HttpMethod.get,
      query: {
        'PageNumber': page,
        'PageSize': pageSize,
        if (venueId != null) 'VenueId': venueId,
        if (keyword != null) 'Keyword': keyword,
        'SortDescending': sortDescending,
      },
    );

    return ApiResponse<PaginatedResponse<VenueReview>>.fromJson(
      res,
      (json) => PaginatedResponse<VenueReview>.fromJson(
        json,
        (item) => VenueReview.fromJson(item),
      ),
    );
  }

  static Future<ApiResponse<int>> deleteReview(int reviewId) async {
    final res = await ApiClient.request(
      '/Review/$reviewId/delete',
      method: HttpMethod.delete,
    );

    return ApiResponse<int>.fromJson(res, (json) => json as int);
  }

  static Future<ApiResponse<int>> updateReview({
    required int reviewId,
    required UpdateReviewRequest request,
  }) async {
    final res = await ApiClient.request(
      '/Review/$reviewId/update',
      method: HttpMethod.put,
      data: request.toJson(),
    );

    return ApiResponse<int>.fromJson(res, (json) => json as int);
  }
}
