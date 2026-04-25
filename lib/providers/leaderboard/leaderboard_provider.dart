import 'package:couple_mood_mobile/models/leaderboard/leaderboard_item.dart';
import 'package:couple_mood_mobile/services/leaderboard/leaderboard_service.dart';
import 'package:flutter/material.dart';

class LeaderboardProvider extends ChangeNotifier {
  bool isLoading = false;

  List<LeaderboardItem> rankings = [];

  Future<void> fetchLeaderboard({required int year, required int month}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await LeaderboardService.getLeaderboard(
        year: year,
        month: month,
      );

      rankings = res.data?.rankings ?? [];
    } catch (e) {
      debugPrint("Leaderboard error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<LeaderboardItem> get top3 =>
      rankings.length >= 3 ? rankings.sublist(0, 3) : rankings;

  List<LeaderboardItem> get others =>
      rankings.length > 3 ? rankings.sublist(3) : [];
}
