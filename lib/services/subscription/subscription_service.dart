import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/subscription/member_subscription.dart';
import 'package:couple_mood_mobile/models/subscription/subscription_package.dart';
import 'package:couple_mood_mobile/services/api_client.dart';

class SubscriptionPackageService {
  static Future<ApiResponse<List<SubscriptionPackage>>>
  getMemberPackages() async {
    final res = await ApiClient.request(
      '/MemberSubscription/packages',
      method: HttpMethod.get,
      query: {'pageNumber': 1, 'pageSize': 10},
    );

    return ApiResponse<List<SubscriptionPackage>>.fromJson(
      res,
      (json) => (json['items'] as List)
          .map((e) => SubscriptionPackage.fromJson(e))
          .toList(),
    );
  }

  /// lấy gói hiện tại
  static Future<ApiResponse<MemberSubscription>>
  getCurrentSubscription() async {
    final res = await ApiClient.request(
      '/MemberSubscription/current',
      method: HttpMethod.get,
    );

    return ApiResponse<MemberSubscription>.fromJson(
      res,
      (json) => MemberSubscription.fromJson(json),
    );
  }
}
