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
    try {
      isLoading = true;
      notifyListeners();
      _inviteResponse = await MemberService.inviteMember(inviteCode);
    } catch (e) {
      error = _inviteResponse?.message ?? '';
      throw Exception('Lỗi khi mời thành viên: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
