import 'package:couple_mood_mobile/models/challenge/challenge_item.dart';
import 'package:couple_mood_mobile/models/challenge/couple_challenge.dart';
import 'package:couple_mood_mobile/services/challenge/challenge_service.dart';
import 'package:flutter/foundation.dart';

class ChallengeDetailProvider extends ChangeNotifier {
  ChallengeItem? challenge;
  CoupleChallenge? progress;

  bool isLoading = false;

  Future<void> loadChallenge(int challengeId) async {
    isLoading = true;
    notifyListeners();

    try {
      final res = await ChallengeService.getChallengeDetail(challengeId);
      challenge = res.data;
    } catch (e) {}

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadProgress(int coupleChallengeId) async {
    isLoading = true;
    notifyListeners();

    try {
      final res = await ChallengeService.getCoupleChallengeDetail(
        coupleChallengeId,
      );
      progress = res.data;
    } catch (e) {}

    isLoading = false;
    notifyListeners();
  }
}
