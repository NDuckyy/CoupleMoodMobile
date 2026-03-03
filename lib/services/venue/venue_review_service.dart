import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/venue/review_request.dart';
import 'package:couple_mood_mobile/models/venue/venue_review_data.dart';
import 'package:couple_mood_mobile/services/api_client.dart';

class VenueReviewService {
  static Future<ApiResponse<VenueReviewData>> getVenueReviews({
    required int venueId,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final res = await ApiClient.request(
        '/VenueLocation/$venueId/reviews',
        method: HttpMethod.get,
        query: {'page': page, 'pageSize': pageSize},
      );

      return ApiResponse<VenueReviewData>.fromJson(
        res,
        (json) => VenueReviewData.fromJson(json),
      );
    } catch (e) {
      throw Exception('Lỗi khi lấy review venue: $e');
    }
  }

  static Future<ApiResponse<void>> submitVenueReview(
    ReviewRequest request,
  ) async {
    try {
      final requestBody = {
        "venueLocationId": request.venueLocationId,
        "checkInId": request.checkInId,
        "content": request.content,
        "rating": request.rating,
        "isAnonymous": request.isAnonymous,
        "images": request.imageUrls ?? [],
      };

      final res = await ApiClient.request(
        '/Review/submit',
        method: HttpMethod.post,
        data: requestBody,
      );

      return ApiResponse.fromJson(res, (json) {});
    } catch (e) {
      throw Exception('Lỗi khi gửi review: $e');
    }
  }
}
