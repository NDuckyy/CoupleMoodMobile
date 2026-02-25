import 'package:couple_mood_mobile/models/coupleInvitation/member_response.dart';
import 'package:couple_mood_mobile/models/coupleInvitation/received_response.dart';
import 'package:couple_mood_mobile/models/coupleInvitation/user_data.dart';
import 'package:couple_mood_mobile/services/couple_invitation_service.dart';
import 'package:flutter/material.dart';

class CoupleInvitationProvider extends ChangeNotifier {
  String? error;
  int currentPage = 1;
  bool isLoading = true;
  bool hasMore = true;

  int inviteCount = 0;
  List<MemberResponse> users = [];
  List<InvitationResponse> receivedInvitations = [];
  UserData? userData;
  List<InvitationResponse> sentInvitations = [];

  Future<void> searchMembers(String? keyword, int page) async {
    error = null;
    isLoading = true;
    notifyListeners();
    try {
      final response = await CoupleInvitationService.searchMembers(
        keyword,
        page,
      );
      fetchReceivedInvitations(null, page);
      if (page == 1) {
        users = response.data?.data ?? [];
      } else {
        users.addAll(response.data?.data ?? []);
      }
      currentPage = page;
      final members = response.data?.pagination.total ?? 0;
      hasMore = members >= 6;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchReceivedInvitations(String? filter, int page) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await CoupleInvitationService.getReceivedInvitation(
        filter,
        page,
      );
      if (response.code != 200) {
        error = response.message;
        return;
      } else {
        receivedInvitations = response.data?.data ?? [];
        inviteCount = response.data?.pagination.total ?? 0;
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> acceptInvitation(int memberId) async {
    error = null;
    notifyListeners();

    try {
      final response = await CoupleInvitationService.acceptInvitation(memberId);
      if (response.code != 200) {
        error = response.message;
      } else {
        await fetchReceivedInvitations(null, 1);
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> rejectInvitation(int memberId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await CoupleInvitationService.rejectInvitation(memberId);
      if (response.code != 200) {
        error = response.message;
      } else {
        await fetchReceivedInvitations(null, 1);
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getMemberProfile(int memberId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await CoupleInvitationService.getMemberProfile(memberId);
      if (response.code != 200) {
        error = response.message;
      } else {
        userData = response.data;
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendInvitation(int receiverMemberId, String message) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await CoupleInvitationService.sendInvitation(
        receiverMemberId,
        message,
      );
      if (response.code != 200) {
        error = response.message;
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSentInvitations(String? filter, int page) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await CoupleInvitationService.getSentInvitation(
        filter,
        page,
      );
      sentInvitations = response.data?.data ?? [];
      if (response.code != 200) {
        error = response.message;
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
