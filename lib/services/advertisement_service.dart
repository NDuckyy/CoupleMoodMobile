import 'package:couple_mood_mobile/models/advertisement/advertisement.dart';
import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/services/api_client.dart';

class AdvertisementService {
  Future<ApiResponse<List<Advertisement>>> fetchAdvertisements(String? placementType) async {
    try {
      final res = await ApiClient.request(
        "/Advertisement",
        query: {"placementType": placementType},
        method: HttpMethod.get,
      );
      return ApiResponse<List<Advertisement>>.fromJson(
        res,
        (json) => Advertisement.listFromJson(json as List<dynamic>),
      );
    } catch (e) {
      throw Exception('Lỗi khi lấy quảng cáo: $e');
    }
  }
}
