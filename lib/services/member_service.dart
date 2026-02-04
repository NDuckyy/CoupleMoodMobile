import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/invite/invite_response.dart';
import 'package:couple_mood_mobile/services/api_client.dart';

class MemberService {
  static Future<ApiResponse<InviteResponse>> inviteMember(
    String inviteCode,
  ) async {
    try {
      final response = await ApiClient.request(
        "/Member/invite",
        method: HttpMethod.post,
        data: {"inviteCode": inviteCode},
      );
      return ApiResponse<InviteResponse>.fromJson(response, (json) => InviteResponse.fromJson(json));
    } catch (e) {
      throw Exception('Lỗi khi mời thành viên: $e');
    }
  }
}
