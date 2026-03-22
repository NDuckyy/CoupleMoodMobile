import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/subscription/subscription_package.dart';
import 'package:couple_mood_mobile/services/api_client.dart';

class SubscriptionPackageService {
  /// Lấy danh sách package theo type (MEMBER / VENUE)
  static Future<ApiResponse<List<SubscriptionPackage>>> getPackagesByType(
    String type,
  ) async {
    try {
      final res = await ApiClient.request(
        '/SubscriptionPackage',
        method: HttpMethod.get,
        query: {'type': type},
      );

      return ApiResponse<List<SubscriptionPackage>>.fromJson(
        res,
        (json) =>
            (json as List).map((e) => SubscriptionPackage.fromJson(e)).toList(),
      );
    } catch (e) {
      throw Exception('Lỗi khi lấy subscription packages: $e');
    }
  }

  /// Shortcut cho MEMBER
  static Future<ApiResponse<List<SubscriptionPackage>>>
  getMemberPackages() async {
    return getPackagesByType('member');
  }
}
