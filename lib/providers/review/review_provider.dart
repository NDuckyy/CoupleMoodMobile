import 'dart:io';
import 'package:couple_mood_mobile/models/venue/couple_mood_type.dart';
import 'package:couple_mood_mobile/models/venue/update_review_request.dart';
import 'package:couple_mood_mobile/services/venue/venue_review_service.dart';
import 'package:flutter/material.dart';
import '../../models/checkin/validate_condition.dart';
import '../../models/venue/review_request.dart';
import '../../services/location_service.dart';
import '../../services/review_service.dart';
import '../../utils/upload_util.dart';

class ReviewProvider extends ChangeNotifier {
  bool isLoading = false;
  String? error;

  List<CoupleMoodType> moods = [];
  bool isLoadingMood = false;

  Future<bool> submitReview({
    required int venueLocationId,
    required int checkInId,
    required int rating,
    required String content,
    required bool isAnonymous,
    required bool isMatched,
    required List<String> localImagePaths,
    required int? coupleMoodTypeId,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      /// 1. validate rating
      if (rating == 0) {
        throw "Vui lòng chọn số sao đánh giá";
      }

      /// 2. lấy location
      final position = await LocationService.getCurrentPosition();
      if (position == null) {
        throw "Không thể lấy vị trí hiện tại";
      }

      /// 3. validate check-in
      final validateRes = await ReviewService.validateCheckIn(
        checkInId,
        ValidateCondition(
          venueLocationId: venueLocationId,
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );

      if (validateRes.code != 200) {
        throw validateRes.message ?? "Bạn không ở gần địa điểm";
      }

      /// 4. upload ảnh (nếu có)
      List<String> uploadedUrls = [];

      if (localImagePaths.isNotEmpty) {
        final files = localImagePaths.map((e) => File(e)).toList();
        uploadedUrls = await UploadUtil.mediaUpload(files);
      }

      /// 5. build request
      final request = ReviewRequest(
        venueLocationId: venueLocationId,
        checkInId: checkInId,
        content: content,
        rating: rating,
        isAnonymous: isAnonymous,
        isMatched: isMatched,
        imageUrls: uploadedUrls,
        coupleMoodTypeId: isMatched ? null : coupleMoodTypeId,
      );

      /// 6. call API
      final res = await VenueReviewService.submitVenueReview(request);

      if (res.code != 200) {
        throw res.message ?? "Gửi đánh giá thất bại";
      }

      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateReview({
    required int reviewId,
    required int venueLocationId,
    required int rating,
    required String content,
    required bool isAnonymous,
    required bool isMatched,
    required List<String> originalImages, // từ BE
    required List<String> currentOldImages, // sau khi user edit
    required List<String> newLocalImages,
    required int? coupleMoodTypeId,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      /// 1. validate
      if (rating == 0) {
        throw "Vui lòng chọn số sao";
      }

      /// update review có cần check location, valid abcd ko nhỉ? Hỏi lại sau

      /// 2. detect deleted images
      final deletedImages = originalImages
          .where((url) => !currentOldImages.contains(url))
          .toList();

      /// 3. upload new images
      List<String> newUploadedUrls = [];

      if (newLocalImages.isNotEmpty) {
        final files = newLocalImages.map((e) => File(e)).toList();
        newUploadedUrls = await UploadUtil.mediaUpload(files);
      }

      /// 4. build request
      final request = UpdateReviewRequest(
        venueLocationId: venueLocationId,
        rating: rating,
        content: content,
        isAnonymous: isAnonymous,
        isMatched: isMatched,
        deletedImageUrls: deletedImages.isEmpty ? null : deletedImages,
        newImages: newUploadedUrls.isEmpty ? null : newUploadedUrls,
        coupleMoodTypeId: isMatched ? null : coupleMoodTypeId,
      );

      /// 5. call API
      final res = await VenueReviewService.updateReview(
        reviewId: reviewId,
        request: request,
      );

      if (res.code != 200) {
        throw res.message ?? "Cập nhật thất bại";
      }

      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMoodTypes() async {
    try {
      isLoadingMood = true;
      notifyListeners();

      final res = await ReviewService.getCoupleMoodTypes();

      if (res.code != 200) {
        throw res.message ?? "Không lấy được mood type";
      }

      moods = res.data ?? [];
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoadingMood = false;
      notifyListeners();
    }
  }
}
