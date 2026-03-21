import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/leaderboard/leaderboard_response.dart';
import 'package:couple_mood_mobile/services/api_client.dart';

class LeaderboardService {
  static Future<ApiResponse<LeaderboardResponse>> getLeaderboard({
    required int year,
    required int month,
    int pageNumber = 1,
    int pageSize = 50,
  }) async {
    try {
      final res = await ApiClient.request(
        '/Leaderboard',
        method: HttpMethod.get,
        query: {
          "year": year,
          "month": month,
          "pageNumber": pageNumber,
          "pageSize": pageSize,
        },
      );

      return ApiResponse<LeaderboardResponse>.fromJson(
        res,
        (json) => LeaderboardResponse.fromJson(json),
      );
    } catch (e) {
      throw Exception('Lỗi khi lấy leaderboard: $e');
    }
  }
}
