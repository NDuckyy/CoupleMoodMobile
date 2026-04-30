import 'package:couple_mood_mobile/models/coupleInvitation/communes.dart';
import 'package:couple_mood_mobile/models/coupleInvitation/provinces.dart';
import 'package:couple_mood_mobile/models/user/interest_model.dart';
import 'package:couple_mood_mobile/models/user/update_profile_request.dart';
import 'package:couple_mood_mobile/models/user/user_model.dart';
import 'package:couple_mood_mobile/services/api_client.dart';
import 'package:couple_mood_mobile/models/api_response.dart';

class UserService {
  static Future<ApiResponse<UserModel>> getMe() async {
    final res = await ApiClient.request("/Auth/me", method: HttpMethod.get);

    return ApiResponse.fromJson(res, (data) => UserModel.fromJson(data));
  }

  static Future<ApiResponse<void>> updateProfile(
    UpdateProfileRequest request,
  ) async {
    final res = await ApiClient.request(
      "/Member/profile",
      method: HttpMethod.put,
      data: request.toJson(),
    );

    return ApiResponse.fromJson(res, (data) {});
  }

  static Future<ApiResponse<List<String>>> getAnimal() async {
    final res = await ApiClient.request("/Animal", method: HttpMethod.get);
    return ApiResponse.fromJson(res, (data) => (data as List).cast<String>());
  }

  static Future<ApiResponse<List<InterestModel>>> getInterests() async {
    final res = await ApiClient.request("/Interest", method: HttpMethod.get);
    return ApiResponse.fromJson(
      res,
      (data) => (data as List).map((e) => InterestModel.fromJson(e)).toList(),
    );
  }

  static Future<ApiResponse<List<String>>> getJobTitles() async {
    final res = await ApiClient.request("/Job", method: HttpMethod.get);
    return ApiResponse.fromJson(res, (data) => (data as List).cast<String>());
  }

  static Future<ApiResponse<int>> getHasActiveSubscription() async {
    final res = await ApiClient.request(
      "/MemberSubscription/has-active",
      method: HttpMethod.get,
    );
    return ApiResponse.fromJson(res, (data) => data["packageId"] as int);
  }

  static Future<List<Provinces>> getProvinces(String date) async {
    final res = await ApiClient.requestForAddress(
      "/$date/provinces",
      method: HttpMethod.get,
    );
    return (res["provinces"] as List).map((e) => Provinces.fromJson(e)).toList();
  }

  static Future<List<Communes>> getCommunes(
    String date,
    String provinceId,
  ) async {
    final res = await ApiClient.requestForAddress(
      "/$date/provinces/$provinceId/communes",
      method: HttpMethod.get,
    );
    return (res["communes"] as List).map((e) => Communes.fromJson(e)).toList();
  }
}
