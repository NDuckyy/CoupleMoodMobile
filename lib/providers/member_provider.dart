import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/invite/invite_response.dart';
import 'package:couple_mood_mobile/services/member_service.dart';
import 'package:flutter/material.dart';

class MemberProvider extends ChangeNotifier {
  ApiResponse<InviteResponse>? _inviteResponse;
  bool isLoading = false;
  String? error;

  ApiResponse<InviteResponse>? get inviteResponse => _inviteResponse;
  Future<void> inviteMember(String inviteCode) async {
    error = null;
    try {
      isLoading = true;
      notifyListeners();
      _inviteResponse = await MemberService.inviteMember(inviteCode);
      if (_inviteResponse!.code != 200) {
        error = _inviteResponse!.message;
      }
    } catch (e) {
      throw Exception('Lỗi khi mời thành viên: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
