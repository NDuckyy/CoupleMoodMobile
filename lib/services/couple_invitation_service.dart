import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/coupleInvitation/member_profile.dart';
import 'package:couple_mood_mobile/models/coupleInvitation/member_response.dart';
import 'package:couple_mood_mobile/models/coupleInvitation/received_response.dart';
import 'package:couple_mood_mobile/models/coupleInvitation/search_response.dart';
import 'package:couple_mood_mobile/models/coupleInvitation/user_data.dart';
import 'package:couple_mood_mobile/services/api_client.dart';
import 'package:flutter/widgets.dart';

class CoupleInvitationService {
  static Future<ApiResponse<SearchResponse<MemberResponse>>> searchMembers(
    String? query,
    int page,
  ) async {
    try {
      final res = await ApiClient.request(
        '/couple-invitations/search',
        method: HttpMethod.get,
        query: {'query': query, 'page': page, 'pageSize': 6},
      );
      return ApiResponse<SearchResponse<MemberResponse>>.fromJson(
        res,
        (json) => SearchResponse<MemberResponse>.fromJson(
          json,
          MemberResponse.fromJson,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Lỗi khi tìm kiếm thành viên: $e');
    }
  }

  static Future<ApiResponse<SearchResponse<ReceivedResponse>>>
  getReceivedInvitation(String? filter, int page) async {
    try {
      final res = await ApiClient.request(
        '/couple-invitations/received',
        method: HttpMethod.get,
        query: {'filter': filter, 'page': page, 'pageSize': 10},
      );
      return ApiResponse<SearchResponse<ReceivedResponse>>.fromJson(
        res,
        (json) => SearchResponse<ReceivedResponse>.fromJson(
          json,
          ReceivedResponse.fromJson,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Lỗi khi nhận lời mời: $e');
    }
  }

  static Future<ApiResponse<void>> getSentInvitation(
    String? filter,
    int page,
  ) async {
    try {
      final res = await ApiClient.request(
        '/couple-invitations/sent',
        method: HttpMethod.get,
        query: {'filter': filter, 'page': page, 'pageSize': 20},
      );
      return ApiResponse<void>.fromJson(res, (json) => null);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Lỗi khi phản hồi lời mời: $e');
    }
  }

  static Future<ApiResponse<void>> breakup() async {
    try {
      final res = await ApiClient.request(
        '/couple-invitations/breakup',
        method: HttpMethod.post,
      );
      return ApiResponse<void>.fromJson(res, (json) => null);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Lỗi khi phá vỡ mối quan hệ: $e');
    }
  }

  static Future<ApiResponse<void>> sendInvitation(
    int receiverMemberId,
    String message,
  ) async {
    try {
      final res = await ApiClient.request(
        '/couple-invitations/send',
        method: HttpMethod.post,
        data: {'receiverMemberId': receiverMemberId, 'message': message},
      );
      return ApiResponse<void>.fromJson(res, (json) => null);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Lỗi khi gửi lời mời: $e');
    }
  }

  static Future<ApiResponse<void>> acceptInvitation(int memberId) async {
    try {
      final res = await ApiClient.request(
        '/couple-invitations/$memberId/accept',
        method: HttpMethod.put,
      );
      return ApiResponse<void>.fromJson(res, (json) => null);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Lỗi khi phản hồi lời mời: $e');
    }
  }

  static Future<ApiResponse<void>> rejectInvitation(int invitationId) async {
    try {
      final res = await ApiClient.request(
        '/couple-invitations/$invitationId/reject',
        method: HttpMethod.put,
      );
      return ApiResponse<void>.fromJson(res, (json) => null);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Lỗi khi phản hồi lời mời: $e');
    }
  }

  static Future<ApiResponse<void>> cancelInvitation(int invitationId) async {
    try {
      final res = await ApiClient.request(
        '/couple-invitations/$invitationId/cancel',
        method: HttpMethod.put,
      );
      return ApiResponse<void>.fromJson(res, (json) => null);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Lỗi khi hủy lời mời: $e');
    }
  }

  static Future<ApiResponse<UserData>> getMemberProfile(int memberId) async {
    try {
      final res = await ApiClient.request(
        '/Users/$memberId',
        method: HttpMethod.get,
      );
      return ApiResponse<UserData>.fromJson(
        res,
        (json) => UserData.fromJson(json),
      );
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Lỗi khi lấy thông tin thành viên: $e');
    }
  }
}
