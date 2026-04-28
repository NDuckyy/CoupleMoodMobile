import 'package:couple_mood_mobile/models/challenge/challenge_item.dart';
import 'package:couple_mood_mobile/models/challenge/couple_challenge.dart';
import 'package:flutter/material.dart';
import 'package:couple_mood_mobile/services/challenge/challenge_service.dart';

class ChallengeProvider extends ChangeNotifier {
  List<ChallengeItem> discoverChallenges = [];
  List<CoupleChallenge> doingChallenges = [];
  List<CoupleChallenge> completedChallenges = [];

  Map<int, ChallengeItem> templateMap = {};

  bool isLoading = false;

  /// ================= LOAD =================
  Future<void> loadChallenges() async {
    isLoading = true;
    notifyListeners();

    try {
      final coupleRes = await ChallengeService.getDoingChallenges();
      final templateRes = await ChallengeService.getChallenges();

      final coupleItems = coupleRes.data?.items ?? [];
      final templateItems = templateRes.data?.items ?? [];

      /// build fresh template map (anti stale)
      templateMap = {for (var c in templateItems) c.id: c};

      /// doing
      doingChallenges = coupleItems
          .where((c) => c.status == "IN_PROGRESS")
          .toList();

      /// completed
      completedChallenges = coupleItems
          .where((c) => c.status == "COMPLETED")
          .toList();

      /// discover (only not joined)
      discoverChallenges = templateItems
          .where((c) => c.isJoined == false)
          .toList();
    } catch (e) {
      debugPrint(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }

  /// ================= JOIN =================
  Future<bool> joinChallenge(int challengeId) async {
    try {
      final res = await ChallengeService.joinChallenge(challengeId);
      final newCouple = res.data;

      if (newCouple != null) {
        /// remove khỏi discover
        discoverChallenges.removeWhere((c) => c.id == challengeId);

        /// add vào doing
        doingChallenges.insert(0, newCouple);

        /// update template (IMMUTABLE)
        if (templateMap.containsKey(challengeId)) {
          final updated = templateMap[challengeId]!.copyWith(isJoined: true);
          templateMap[challengeId] = updated;
        }

        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  /// ================= LEAVE =================
  Future<bool> leaveChallenge(int coupleChallengeId) async {
    try {
      await ChallengeService.leaveChallenge(coupleChallengeId);

      final index = doingChallenges.indexWhere(
        (c) => c.id == coupleChallengeId,
      );

      if (index != -1) {
        final removed = doingChallenges.removeAt(index);

        /// restore template
        final template = templateMap[removed.challengeId];

        if (template != null) {
          final updated = template.copyWith(isJoined: false);

          templateMap[removed.challengeId] = updated;

          /// tránh duplicate
          discoverChallenges.removeWhere((c) => c.id == updated.id);
          discoverChallenges.insert(0, updated);
        }
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  /// ================= CLAIM =================
  Future<bool> claimReward(int coupleChallengeId) async {
    try {
      await ChallengeService.claimReward(coupleChallengeId);

      /// OPTION 1: nhẹ (không reload)
      final index = doingChallenges.indexWhere(
        (c) => c.id == coupleChallengeId,
      );

      if (index != -1) {
        final item = doingChallenges.removeAt(index);
        completedChallenges.insert(0, item);
      }

      notifyListeners();

      /// OPTION 2 (nếu cần strict sync backend):
      // await loadChallenges();

      return true;
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }
}
