import 'package:couple_mood_mobile/models/user/update_profile_request.dart';
import 'package:couple_mood_mobile/models/user/update_profile_response.dart';
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
}
