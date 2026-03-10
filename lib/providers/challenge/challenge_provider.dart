import 'package:couple_mood_mobile/models/challenge/challenge_item.dart';
import 'package:couple_mood_mobile/models/challenge/couple_challenge.dart';
import 'package:flutter/material.dart';
import 'package:couple_mood_mobile/services/challenge/challenge_service.dart';

class ChallengeProvider extends ChangeNotifier {
  List<ChallengeItem> discoverChallenges = [];
  List<CoupleChallenge> doingChallenges = [];
  List<CoupleChallenge> completedChallenges = [];

  /// giữ template challenge để restore khi leave
  Map<int, ChallengeItem> templateMap = {};

  bool isLoading = false;

  Future<void> loadChallenges() async {
    isLoading = true;
    notifyListeners();

    try {
      final coupleRes = await ChallengeService.getDoingChallenges();
      final templateRes = await ChallengeService.getChallenges();

      final coupleItems = coupleRes.data?.items ?? [];
      final templateItems = templateRes.data?.items ?? [];

      /// build template map
      templateMap = {for (var c in templateItems) c.id: c};

      doingChallenges = coupleItems
          .where((c) => c.status == "IN_PROGRESS")
          .toList();

      completedChallenges = coupleItems
          .where((c) => c.status == "COMPLETED")
          .toList();

      discoverChallenges = templateItems
          .where((c) => c.isJoined == false)
          .toList();
    } catch (e) {
      debugPrint(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }

  /// JOIN CHALLENGE
  Future<bool> joinChallenge(int challengeId) async {
    try {
      final res = await ChallengeService.joinChallenge(challengeId);
      final newCouple = res.data;

      if (newCouple != null) {
        discoverChallenges.removeWhere((c) => c.id == challengeId);

        doingChallenges.insert(0, newCouple);

        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  /// LEAVE CHALLENGE
  Future<bool> leaveChallenge(int coupleChallengeId) async {
    try {
      await ChallengeService.leaveChallenge(coupleChallengeId);

      final index = doingChallenges.indexWhere(
        (c) => c.id == coupleChallengeId,
      );

      if (index == -1) return false;

      final removed = doingChallenges.removeAt(index);

      /// restore template challenge
      final template = templateMap[removed.challengeId];

      if (template != null) {
        discoverChallenges.insert(0, template);
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }
}
