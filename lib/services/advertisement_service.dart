import 'package:couple_mood_mobile/models/advertisement/advertisement.dart';
import 'package:couple_mood_mobile/models/api_response.dart';

class AdvertisementService {
  Future<ApiResponse<List<Advertisement>>> fetchAdvertisements() async {
    try {
      final ads = [
        Advertisement(
          type: "SPECIAL_EVENT",
          advertisementId: 1,
          venueId: 101,
          specialEventId: null,
          bannerUrl:
              "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/ladies-night-party-landscape-flyer-design-template-d668555026232c2b79a9ae0dd6fd4d38_screen.jpg?ts=1601364133",
        ),
        Advertisement(
          type: "SPECIAL_EVENT",
          advertisementId: 2,
          venueId: null,
          specialEventId: 201,
          bannerUrl:
              "https://img.pikbest.com/backgrounds/20210618/colorful-coffee-shop-promotion-banner_6021541.jpg!w700wp",
        ),
      ];

      return ApiResponse<List<Advertisement>>(
        code: 200,
        message: "Quảng cáo được tải thành công",
        data: ads,
      );
    } catch (e) {
      throw Exception('Lỗi khi lấy quảng cáo: $e');
    }
  }
}
